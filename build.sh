@echooff

odin build ./examples -out=exe
echo "Memory check!"
valgrind --leak-check=full --track-origins=yes ./examples/examples.bin --count=100 --pi=8.13 --toggle --msg="Hello, world"
echo "Program:"
./examples/examples.bin --count=100 --pi=8.13 --toggle --msg="Hello, world"