#!/bin/bash
# Usage: grade dir_or_archive [grades.csv]

# Ensure realpath 
realpath . &>/dev/null
HAD_REALPATH=$(test "$?" -eq 127 && echo no || echo yes)
if [ "$HAD_REALPATH" = "no" ]; then
  cat > /tmp/realpath-grade.c <<EOF
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char** argv) {
  char* path = argv[1];
  char result[8192];
  memset(result, 0, 8192);

  if (argc == 1) {
      printf("Usage: %s path\n", argv[0]);
      return 2;
  }
  
  if (realpath(path, result)) {
    printf("%s\n", result);
    return 0;
  } else {
    printf("%s\n", argv[1]);
    return 1;
  }
}
EOF
  cc -o /tmp/realpath-grade /tmp/realpath-grade.c
  function realpath () {
    /tmp/realpath-grade $@
  }
fi

INFILE=$1
test -z "$INFILE" && INFILE="."
INFILE=$(realpath "$INFILE")
# grades.csv is optional
GRADES=""
test -z "$2" || GRADES=$(realpath "$2")
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# Absolute path to this script
THEPACK="${DIR}/$(basename "${BASH_SOURCE[0]}")"
STARTDIR=$(pwd)

# Split basename and extension
BASE=$(basename "$INFILE")
EXT=""
if [ ! -d "$INFILE" ]; then
  BASE=$(echo $(basename "$INFILE") | sed -E 's/^(.*)(\.(zip|tar\.(gz|bz2|xz)))$/\1/g')
  EXT=$(echo  $(basename "$INFILE") | sed -E 's/^(.*)(\.(zip|tar\.(gz|bz2|xz)))$/\2/g')
fi

# Setup working dir
rm -fr "/tmp/$BASE-test" || true
mkdir "/tmp/$BASE-test" || ( echo "Could not mkdir /tmp/$BASE-test"; exit 1 )
cd "/tmp/$BASE-test"

function cleanup () {
  cd "$STARTDIR"
  rm -fr "/tmp/$BASE-test"
  test "$HAD_REALPATH" = "yes" || rm /tmp/realpath-grade* &>/dev/null
  return 1 # helps with precedence
}

# Avoid messing up with the running user's home directory
# Not entirely safe, running as another user is recommended
export HOME=.

# Unpack the submission (or copy the dir)
if [ -z "$EXT" ]; then
  cp -r "$INFILE" . || cleanup || exit 1 
elif [ "$EXT" = ".zip" ]; then
  unzip    "$INFILE" || cleanup || exit 1
elif [ "$EXT" = ".tar.gz" ]; then
  tar zxf "$INFILE" || cleanup || exit 1
elif [ "$EXT" = ".tar.bz2" ]; then
  tar jxf "$INFILE" || cleanup || exit 1
elif [ "$EXT" = ".tar.xz" ]; then
  tar Jxf "$INFILE" || cleanup || exit 1
else
  echo "Unknown extension $EXT"; cleanup; exit 1
fi

# There must be exactly one top-level dir inside the submission
NDIRS=$(find . -mindepth 1 -maxdepth 1 -type d | wc -l)
test "$NDIRS" -gt 1 && \
  echo "Malformed archive! Expected exactly one directory" && exit 1
test  "$NDIRS" -eq 0  -a  "$(find . -mindepth 1 -maxdepth 1 -type f | wc -l)" -eq 0  && \
  echo "Empty archive!"
if [ "$NDIRS" -eq 1 ]; then
  cd "$(find . -mindepth 1 -maxdepth 1 -type d)"
fi

# Deploy additional binaries so that validate.sh can use them
mkdir ../grade-driver-tools
test "$HAD_REALPATH" = "yes" || cp /tmp/realpath-grade ../grade-driver-tools/realpath
export PATH="$PATH:$(realpath grade-driver-tools)"

# Unpack the testbench and grade
tail -n +$(($(grep -ahn  '^__TESTBENCH_MARKER__' "$THEPACK" | cut -f1 -d:) +1)) "$THEPACK" | tar zx
cd testbench || cleanup || exit 1
./validate.sh || cleanup || exit 1
if [ -n "$GRADES" ]; then
  echo "$BASE$EXT,$(cat grade)" >> "$GRADES"
fi
echo -e "Grade for $BASE$EXT: $(cat grade)"

cleanup || true

exit 0

__TESTBENCH_MARKER__
� Z?l[ �Z�s�V��'nh�`˱����I`�$�%�v�̍u�Z��+65�/L:0ӧ������ν�,'����Nu&ݯs��ǅX��D��ƥ_V ��������R�������jkc}}s������%Z��H�B�b]��S�����?(Ĺ��7���ǿ�����.���2���67�N�P?����I�r���ٿ}�h���~���h�>�-��SJ(r��=�V2I��� _%�m"<E"�6�F�"�K����.W���p�о�O"YW�8)�4��+j�n�Xx����c$r q�����Co �5GA,&W�,cŔ`kO�8��b�{wgG�θC|M~F��v'oI�]��#_L~�|Rwy���"����"�\"9�m�z�@	e.dc�iۍ���­��2��	d�Bz�jw$��t�"��z*����z_2�kw�QN��-�������ܡ�����e�kT���,GE�jA���X�(|&��::|�pg�hk����"ri��2�"(-�s���ğ��o�CjoQO���R�k͹^$=�U�g�䋡0y�����5���}6Hܕ��g��A�P�*9Q1]q�5s�'�-VSFl�� �a��)_w E��|�E�+|֮�J0�F���sxB[�#��g��&˶�=���6_S�E������`P���j�;Q��5��I�7Ei-Vթ6����CZ�B����F�t���Q#H;uMI�7ڌ=_zQbF��TC��8�hk��fj���([�1�#�[�k�l�=}a�"�����8�^dA�m��
;m�V�&>�t�����h������̻������yc���E����ś3��
��LG�80��Xj��W]�'�1��lɆ��[&�ǧR��V�=BK��2y��E)�~���G���'iAQ6v�ˋ՝��_��_�(
�u�[�f�7Q�6V�~�C��]0j]�GT����ҧ�����)��?O�xn@��&?^���L~���hC��#��b���X��m-�����Lxf!*��ɏn��͑15Nȟu���Q)"E�C�C��e�I#y��#9 @���y �t'��<D+�_ӱ���S�_�����-CB-S���ET��%l]M~�E�O	�J�k����@s�3z�Br��� �C�L� �9�3���@�2B*������c�'�C��%͇#8�9^�H����4Qh�����ǟݿ}����X=JțT�`�ܵ+��X�/w]r��0��w�Sb+f��Y�7g�0Uaf�=(r�R�&�me��V�:G�AO�_R�$PD0%�@i9�j��?yC������tޭ!�́!3Pޗ�CU9�`��UVB[5�v��n�n�ek�ܺc$m���]�3�/]ϸ�����ν��G�i@ �%\��s�ܙ�{�N�R�l��!�7��[�� ����J�o�Pq����,�b�e���
�C1A��٭,���9W�������H<W��V����������[]Y�\omp����,���>Yh 27���Vw�w0���\͆��� tN=�Qh��iH+t��ƃ؍"��z�@UM�=-[�	��B�ŧ2��4��������
���3�v�*�i��y�,���mj�0V���<�?B��4�beݶvw�
���'�X<�P�S�u��ޘO��ed����t�0
@�(Ni<5ʑ��Z��-3�-lQe����'����OoYY��Siz)P�D�9٠�1�Y�
fm�`
"�r�N�R)��t�՜���Q��fְ@y��5���r�	J�Y%P��[�]d�6�#I1n�����<	I�o}m�V!*z���<֎��>�Ϛ�d��ހ�:j����Q�Q�eoc}f�_��7�4&zޥ::-F
u�`!��f�k�N��t�L�f�1j�C�<7��*��Zw%^ߋ4>�d���/(��⨉o%�GK��-�Fɶn߻?�*NZ�:E�ю�"Rg�c/�*��MbTjM�����W,�Xx�������ƗW�O�h����;ϯV�o.��W�	X�8�씽��Y�)|�g�kX�,2}E?��V�J�zy5��i�-�UJ���t��X�U9g��3��3g�����_um��ڦ
dq����f����������PUK�93�Zp�Ǵ�:qMz�����g\���3I�н$0�e0%c���		&����7YȅȢݕ���p	�L��d,Dމy`C���CX�����+���4���p�FѼj?e��'\�k&ڝ`+�;���Q��	�!�dT���}j�)��#��S��ǆ?7qXt�ȡ���T�P>ژ�?�D!�#�6ٛ7��u�py������1Ԙp��D���=ȏ��)��M(gČ(n�� z����[8��-m���>¸���#�~(��+[�V�<��b�C�����&ml�������;y��B.:]AF�7.��m�a�+������Zk�:3�z}����XX_���5,���nq��W[�%U����y
�c1��u������ǧj{�5��x�F���ԯ?�Z�8�c�޶����ޒu���s5IcwJٓ���i8V�XU�q��'"{��8�]4�UO��6&��Z���lʢUڼFkMass�i��`��������$����}료-��K����D�>=��EC�=�0���Ϙ���Ӫ� f�g�H��<� ���zmsc|����=s1]��`)Y��l�S�j:@��p�;C�'zqN�.����ʴ�jΫ�s��f�����9��taź����N��q|\͟��%_���x����O�Ӿ���s<��%%?�1�=�"ntޏ�ЕN�����9��6sJ�yuF���[r�:�����1~4f��A�Z*�t4�b���#an1���qg�JJ���<���N�	�N�z�?#�]ĝ�]ĝMk����^���.gJ@zfvt�t:��3_����3��Y����p�E/,l�0��tqź���MZIs������������o676���fk��Z����7��j�N�+�n�����=z�Ԧ�w�*�(��k��P�P�P�P����Qgآ�3��#��~a�6{�09�A�.~�꽳�E��@���x�=�V�:W6ݤ��̠w_���s�%Ɂ�������=��A!��	���Y��(<��H���ZZ��)m/�ĸuS,����/"&$w�.� QY�2K֝{�{�ԃ�z�P�ʹr+�+�^J�W�8M����ֻ�P�jC=n4h/�r�Th*�����7�c�mt�mZ�a�����%�PB	%�PB	%�PB	%�PB	%�PB	%�PB	%�PB	%�PB	%�PB	%�PB	$�7U��� P  