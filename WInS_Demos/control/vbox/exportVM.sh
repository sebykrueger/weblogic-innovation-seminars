#!/bin/sh

PROMPT=true
EXPORT_VBOX=true
ZIP_OVA=true
OVA_PRODUCT_URL="http://retriever.us.oracle.com/apex/f?p=121:3:2027314285611264::NO:RP:P3_PAGE_ID:2129"
OVA_VERSION="12.1.2-v2"
OVA_EULA_FILE="/Users/jeffreyawest/Data/mycode/github/oracle-weblogic/weblogic-innovation-seminars/WInS_Demos/control/vbox/eula.txt"

parse_control_settings()
{
	for param in $*
	do
		if [ "${param}" == "-y" ]; then
			PROMPT=false
		elif [ "${param}" == "nozip" ]; then
			ZIP_OVA=false
		elif [ "${param}" == "noexport" ]; then
			EXPORT_VBOX=false
		fi
	done
}

set -e

VBOX_NAME="${1}"
VBOX_OUTPUT_NAME="wins-${OVA_VERSION}.ova"
VBOX_OUTPUT_DIR="$3"
ZIP_OUTPUT_DIR="${4-$VBOX_OUTPUT_DIR}"

parse_control_settings $*

echo "Exporting VM=[$VBOX_NAME] to OVA=[$VBOX_OUTPUT_NAME] in directory=[$VBOX_OUTPUT_DIR]"
echo "Zip output dir=[$ZIP_OUTPUT_DIR]"

if [ "${PROMPT}" != false ]; then

	read -p "Continue? [y/N]" inputRead

	if [ "${inputRead}" != "y" ]; then
		exit 1
	fi
fi
if [ -f ${VBOX_OUTPUT_DIR}/${VBOX_OUTPUT_NAME} ]; then
	echo "Removing existing file: ${VBOX_OUTPUT_DIR}/${VBOX_OUTPUT_NAME}"
	rm -v ${VBOX_OUTPUT_DIR}/${VBOX_OUTPUT_NAME}
fi

mkdir -p ${VBOX_OUTPUT_DIR}
mkdir -p ${ZIP_OUTPUT_DIR}

if [ "${EXPORT_VBOX}" != "false" ];
then
  EXPORT_CMD="VBoxManage export ${VBOX_NAME} --output ${VBOX_OUTPUT_DIR}/${VBOX_OUTPUT_NAME}  --vsys 0 "
  EXPORT_CMD=" ${EXPORT_CMD} --product \"WInS VirtualBox VM\""
  EXPORT_CMD=" ${EXPORT_CMD} --producturl ${OVA_PRODUCT_URL}"
  EXPORT_CMD=" ${EXPORT_CMD} --version ${OVA_VERSION}"
  EXPORT_CMD=" ${EXPORT_CMD} --eulafile ${OVA_EULA_FILE}"

	if [ "${OVA_PRODUCT}" != "" ]; then
	  EXPORT_CMD = "${EXPORT_CMD} "
	fi

	echo "Exporting VBOX=[${VBOX_NAME}] with command: ${EXPORT_CMD}
	${EXPORT_CMD}
fi

if [ "${ZIP_OVA}" != "false" ]; then
	ZIP_CMD= "zip -j -s 1g -1 ${ZIP_OUTPUT_DIR}/${VBOX_OUTPUT_NAME}.zip ${VBOX_OUTPUT_DIR}/${VBOX_OUTPUT_NAME}"
	echo "Zipping VBOX with command: ${ZIP_CMD}"
	${ZIP_CMD}
fi