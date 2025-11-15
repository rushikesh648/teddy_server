Install NASM (if needed):
```
bash
sudo apt update
sudo apt install nasm -y
```
save

```
bash
mkdir TeddyServerProject
cd TeddyServerProject
nano teddy_server.asm
```

compile and link
```
bash
nasm -f elf64 teddy_server.asm -o teddy_server.o
ld teddy_server.o -o teddy_server.out

```
Run
```
./teddy_server.out
```
