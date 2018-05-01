

VERSION=$(shell cat VERSION)
DIST="dist/os-${VERSION}"

build: tarball
	mkdir -p ${PWD}/dist/SOURCES
	rpmbuild -D "_topdir ${PWD}/dist" -ba os.spec

tarball: clean
	mkdir -p ${DIST} ${PWD}/dist/SOURCES
	cp -r README.md LICENSE VERSION os.spec os Makefile ${DIST}
	tar -C dist -czf dist/os-${VERSION}.tar.gz os-${VERSION}
	mv ${DIST}.tar.gz ${PWD}/dist/SOURCES

clean:
	rm -rf ./dist
