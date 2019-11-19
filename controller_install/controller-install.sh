# Pull and run docker image for controller
sudo docker pull wangso/controller
sudo docker run -dit -p 80:80 -p 6633:6633 -p 3306:3306 -p 33060:33060 --name controller wangso/controller
sudo docker exec -it controller service apache2 start
sudo docker exec -it controller service mysql start
