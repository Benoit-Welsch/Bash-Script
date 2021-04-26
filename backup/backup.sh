OUTPUT="/media/nvme/backup"

APPKEYID= ###FILL###
APPKEY= ###FILL###
BUCKET= ###FILL###

function error() {
    echo -e "\e[91m🤬 $1 \e[39m"
    exit 1
}

echo "${2}"

# Check folder exist && input folder var exist
if [ -z "$1" ];then
    error "Please provide an name"
elif [ -z "$2" ];then
    error "Please provide an input folder"
elif [ ! -d "$2" ];then
    error "Please provide a valid input folder"
fi

# Var
name=$1
folder=$2
configFolder="${OUTPUT}/${name}/"
fileName="$OUTPUT/$name/$name-$(date --rfc-3339=date).tar.lzma"

# Authenticate to backblaze
./b2 authorize-account $APPKEYID $APPKEY

# Create folder
mkdir -p $OUTPUT
mkdir -p $configFolder


if [ ! -f $fileName ]; then
    # Create backup archive
    tar -Jcvf $fileName \
    --listed-incremental="$configFolder/$name-incremental.config" $folder
    
    # Upload archive to backblaze
    ./b2 upload-file $BUCKET $fileName "$name/$name-$(date --rfc-3339=date).tar.lzma" > /dev/null
    ./b2 upload-file $BUCKET "$configFolder/$name-incremental.config" "$name/$name-incremental.config" > /dev/null
    
else
    error "Backup ${name} already made today"
fi
