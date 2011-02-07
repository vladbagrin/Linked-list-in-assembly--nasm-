# Test if there is a filename argument
if test $# -eq 0;
then
    echo "Usage: asm filename"
    exit 0
fi

# If there is a file to be assembled
nasm -f elf $1
name=$(echo $1 | cut -d. -f1)
shift
gcc -o $name $name.o
rm $name.o
