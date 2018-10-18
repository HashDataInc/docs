const fs = require('fs'),
    path = require('path'),
    Parser = require('markdown-parser2')

function generate(parser, root, prefix, path, level) {
    result = parser.parse(
        fs.readFileSync(`${path}`, { encoding: 'utf8' }))

    let title = 'unknown'

    if (result.headings.length) {
        title = result.headings[0].trim()
    }

    msg = `${Array(level).join('    ')}- [${title}](${path})\n`

    return msg
}


function init() {
    const parser = new Parser(),
        root = './',
        readmeFilename = "README.md",
        summaryFilename = 'SUMMARY.md'

    let ret = Promise.resolve(),
        summaryContent = ''

    const isReadme = path => path.includes(readmeFilename)

    const walkSync = (dir, pattern, ignorelist = [], level = 1, prefix = '') => {
        let index = level == 1 ? 1 : 0

        fs.readdirSync(dir).sort((a, b) => {
            if (isReadme(a) && !isReadme(b)) {
                return -1
            } else if (!isReadme(a) && isReadme(b)) {
                return 1
            }

            return a < b ? -1 : a > b ? 1 : 0
        }).forEach(file => {
            let isDir = fs.statSync(path.join(dir, file)).isDirectory()

            if ((file.match(pattern) && !ignorelist.includes(file)) || (isDir && !ignorelist.includes(file))) {
                if (index == 0) {
                    adding = prefix
                } else {
                    adding = prefix ? prefix + '.' + index : '' + index
                }

                if (isDir) {
                    walkSync(path.join(dir, file), pattern, ignorelist, level + 1, adding)
                } else {
                    summaryContent += generate(parser, root, adding, path.join(dir, file), index == 0 ? level - 1 : level)
                }

                if (level == 1) {
                    summaryContent += '\n\n'
                }

                index = index + 1
            }
        })
    };

    walkSync(root, `\.md$`, ['node_modules', '.git', '_book', summaryFilename])

    fs.writeFileSync(`${root}/${summaryFilename}`, summaryContent, { encoding: 'utf8' })

    console.log(`\x1b[32m${summaryFilename} generated successfully.`)
}

init()