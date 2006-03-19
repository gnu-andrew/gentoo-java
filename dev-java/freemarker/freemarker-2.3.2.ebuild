# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg

DESCRIPTION=" FreeMarker is a template engine; a generic tool to generate text output (anything from HTML to autogenerated source code) based on templates."
HOMEPAGE="http://freemarker.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

# TODO figure out license
LICENSE=""
SLOT="2.3"
KEYWORDS="~amd64 ~x86"
IUSE="doc jikes"

# TODO determine vm requirement
DEPEND=">=virtual/jdk-1.4
	jikes? ( dev-java/jikes )
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.4
	=dev-java/servletapi-2.3*
	=dev-java/jdom-1.0_beta9*
	=dev-java/jaxen-1.1*
	=dev-java/dom4j-1*
	dev-java/saxpath
	dev-java/jython
	=dev-java/avalon-logkit-2.0*
	dev-java/log4j"

GETJARS_ARG="servletapi-2.3,jdom-1.0_beta9,jaxen-1.1,dom4j-1,saxpath,jython,avalon-logkit-2.0,log4j"

src_compile() {
	local antflags="-Dproject.name=${PN} jar"
	antflags="${antflags} -lib $(java-pkg_getjars ${GETJARS_ARG})"
	use jikes && antflags="-Dbuild.compiler=jikes ${antflags}"
	use doc && antflags="${antflags} javadoc"

	ant ${antflags} || die "Compilation failed"
}

src_install() {
	java-pkg_dojar lib/${PN}.jar
	dodoc README.txt

	# TODO there's more docs that could be installed
	use doc && java-pkg_dohtml -r build/api
}
