### Gerando a Imagem
```
docker build -t hadoop . 
```
*This command should be executed from this git directory's root
### Gerando o Conainer

```
docker run -p 7077:7077 -p 8080:8080 -p 8088:8088 -p 9000:9000 --name my-hadoop-container -d hadoop
```
