### Gerando a Imagem
```
docker build -t hadoop . 
```
*This command should be executed from this git directory's root
### Gerando o Conainer

```
docker run -p 8088:8088 -p 9000:9000 -p 50070:50070 -p 9864:9864 -p 9870:9870 -p 50075:50075 -p 50030:50030 -p 50060:50060 --name my-hadoop-container -d hadoop
```
