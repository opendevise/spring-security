'use strict'

module.exports.register = function () {
  this.once('contentAggregated', ({ contentAggregate }) => {
    for (const { origins } of contentAggregate) {
      for (const origin of origins) {
        if (origin.reftype === 'tag' && origin.refname === '5.7.3') {
          origin.descriptor.ext = {
            collector: {
              run: {
                command: 'gradlew --no-scan -PbuildSrc.skipTests=true "-Dorg.gradle.jvmargs=-Xmx3g -XX:+HeapDumpOnOutOfMemoryError" :spring-security-docs:generateAntora',
                local: true,
              },
              scan: {
                dir: './build/generateAntora',
              },
            }
          }
        }
      }
    }
  })
}
