# Домашнее задание к занятию "15.1. Организация сети"
## Студент: Александр Недорезов

Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако и дополнительной части в AWS по желанию. Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. 

Перед началом работ следует настроить доступ до облачных ресурсов из Terraform используя материалы прошлых лекций и [ДЗ](https://github.com/netology-code/virt-homeworks/tree/master/07-terraform-02-syntax ). А также заранее выбрать регион (в случае AWS) и зону.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)
> 
> 1. Создать VPC.
> - Создать пустую VPC. Выбрать зону.
> 2. Публичная подсеть.
> - Создать в vpc subnet с названием public, сетью 192.168.10.0/24.
> - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1
> - Создать в этой публичной подсети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.
> 3. Приватная подсеть.
> - Создать в vpc subnet с названием private, сетью 192.168.20.0/24.
> - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс
> - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее и убедиться что есть доступ к интернету
> 
> Resource terraform для ЯО
> - [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet)
> - [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table)
> - [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance)
> ---

### Решение:

С помощью Terraform развернул все необходимые ресурсы в Yandex Cloud [terraform/](terraform)
- в [variables.tf](terraform/variables.tf) объявлены переменные с параметрами для всех объектов, объединены в map-ы для удобства. Сами значения (только публичные) заданы в [public.auto.tfvars](terraform/public.auto.tfvars).
Переменными настраиваются параметры ВМ и VPC, map key используется как имя создаваемого объекта.
- в [network.tf](terraform/network.tf) описано создание `VPC` и `subnets`, а также `route table`
- в [.tf](terraform/main.tf) описано создание шаблона `cloud-init`, получение `images` id и самих `Compute Instance` через for_each

Выполнил `terraform apply`:
![](img/01.png)

Созданные ресурсы в YC:
![](img/06.png)
![](img/07.png)

Подключился к `public-ВМ`, проверил доступ в интернет:
![](img/02.png)

Подключился к `private-ВМ`, предварительно получив секреты для ssh(`scp /home/nedorezov/.ssh/id_ed25519* nedorezov@51.250.8.185:/home/nedorezov/.ssh/`).   
Проверил доступ в интернет, все ок:
![](img/03.png)
![](img/04.png)

Дополнительно убедился, что запрос идет через NAT-инстанс:
![](img/05.png)

