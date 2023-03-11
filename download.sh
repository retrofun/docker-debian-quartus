#!/bin/bash

quartus_installer='Quartus-web-13.1.0.162-linux.tar'
if [[ ! -f "${quartus_installer}" ]]; then
  # Intel link: https://downloads.intel.com/akdlm/software/acdsinst/13.1/162/ib_tar/Quartus-web-13.1.0.162-linux.tar
  wget http://download.altera.com/akdlm/software/acdsinst/13.1/162/ib_tar/"${quartus_installer}"
  [[ ${?} -ne 0 ]] && exit 1
fi
if [[ "$(md5sum "${quartus_installer}")" != "ba705f9d15f3a43ab7e86d297f394ee3  ${quartus_installer}" ]]; then
  echo "error: md5sum of ${quartus_installer} does not match"
  exit 1
fi
echo "${quartus_installer}: OK"

quartus_update='QuartusSetup-13.1.4.182.run'
if [[ ! -f "${quartus_update}" ]]; then
  # Intel link: https://downloads.intel.com/akdlm/software/acdsinst/13.1.4/182/update/QuartusSetup-13.1.4.182.run
  wget http://download.altera.com/akdlm/software/acdsinst/13.1.4/182/update/"${quartus_update}"
  [[ ${?} -ne 0 ]] && exit 1
fi
if [[ "$(md5sum "${quartus_update}")" != "172c8cd0eb631b988516f1182054f976  ${quartus_update}" ]]; then
  echo "error: md5sum of ${quartus_update} does not match"
  exit 1
fi
echo "${quartus_update}: OK"

libpng12_amd64='libpng12-0_1.2.50-2+deb8u3_amd64.deb'
if [[ ! -f "${libpng12_amd64}" ]]; then
  wget http://ftp.us.debian.org/debian/pool/main/libp/libpng/"${libpng12_amd64}"
  [[ ${?} -ne 0 ]] && exit 1
fi
if [[ "$(md5sum "${libpng12_amd64}")" != "c3135be0c3b8bed709e48913e63b2b28  ${libpng12_amd64}" ]]; then
  echo "error: md5sum of ${libpng12_amd64} does not match"
  exit 1
fi
echo "${libpng12_amd64}: OK"

libpng12_i386='libpng12-0_1.2.50-2+deb8u3_i386.deb'
if [[ ! -f "${libpng12_i386}" ]]; then
  wget http://ftp.us.debian.org/debian/pool/main/libp/libpng/"${libpng12_i386}"
  [[ ${?} -ne 0 ]] && exit 1
fi
if [[ "$(md5sum "${libpng12_i386}")" != "13093cead77b73fd7b9a2772b5811ae1  ${libpng12_i386}" ]]; then
  echo "error: md5sum of ${libpng12_i386} does not match"
  exit 1
fi
echo "${libpng12_i386}: OK"

freetype='freetype-2.4.12.tar.gz'
if [[ ! -f "${freetype}" ]]; then
  wget http://download.savannah.gnu.org/releases/freetype/freetype-old/"${freetype}"
  [[ ${?} -ne 0 ]] && exit 1
fi
if [[ "$(md5sum "${freetype}")" != "e3057079a9bb96d7ebf9afee3f724653  ${freetype}" ]]; then
  echo "error: md5sum of ${freetype} does not match"
  exit 1
fi
echo "${freetype}: OK"

exit 0
