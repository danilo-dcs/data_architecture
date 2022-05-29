### Gerando a Imagem
```
docker build -t hadoop . 
```
### Gerando o Conainer

```
docker run -p 8088:8088 --name my-hadoop-container -d hadoop
```
