### Инфраструктура

| Окружение | Серверы | IP адрес |Описание | Сервисы / Инструменты |
|-----------|---------|----------|----------|----------------------|
| Build | build-develop-01 | 172.17.0.102 | Сервер для непрерывной интеграции и доставки | Docker, Gitlab-Runner |
| Testing | testing-app-01 | 172.17.0.103 | UnitTest, SmokeTest, ClearDBTest | Postgres, Docker, Gitlab-Runner |
| CI | ci-app-01 | 172.17.0.101 | Тестовый сервер Бэкенда | Postgres, Nginx, Docker, Gitlab-Runner, RMQ |
| CI | ci-app-02 | 172.17.0.109 | Тестовый сервер Бэкенда | Postgres, Nginx, Docker, Gitlab-Runner |
| CI | ci-app-05 | 172.17.0.108 | Тестовый сервер Бэкенда | Postgres, Nginx, Docker, Gitlab-Runner |
| RC | rc-app-01 | 172.17.0.105 |RC сервер Бэкенда | Postgres, Docker, Gitlab-Runner, RMQ |
| RC | rc-app-02 | 172.17.0.110 |RC сервер Бэкенда | Postgres, Docker, Gitlab-Runner, RMQ |
| Production | prod-app-01 | 172.17.0.106 | Релизный  сервер Бэкенда | Postgres, Docker, Gitlab-Runner, RMQ |
| Services | srv-metrics-01 | 172.17.0.104 | Сервер для мониторинга и логирования | Prometheus, Grafana |
| Services | srv-backups-01 | 172.17.0.107 | Сервер для хранения бэкапов и синхронизации | Rsync |


### Ноды
| тег | vm | нода | диск |
|----------|----------|----------|--------------------|
| gw | шлюзовые | | |
| | | 21 | nas_hdd или hdd |
| client | клиентские на наших мощностях | | |
| | | 21 | nas_hdd |
| | или | 24ha->25 | nas_ssd |
| release | релизы внутренние и публичные | | |
| | | 2ha->4 | nas_ssd |
| dev test cicd | разработка | | |
| | | 25ha->24 | nas_ssd |
| test/pi/bi | | 6 | local_ssd local_hdd|

### Диски
резервирование - nas
быстродействие - ssd
при отсутствии требований к сервису - nas_hdd > local_hdd(можно, но лучше избегать) > nas_ssd > local_ssd(есть на 6)
efi и cloud init пока что мигрируем вместе с вм на nas <- надо протестировать как отработает перенос вм с настроенным ha на новую ноду, когда пропадает нода на которой cloud init и efi/bios диск на local_lvm .

В наличии
| хранилище | диск | назначение |
|----------|----------|--------------------|
|  qnap ssd 13Tb | | |
| |   SSD1_Qnap13 13Tb | релизы и клиентские на наших мощностях для которых критично быстродействие |
| |                    | разработка для которой критична сохранность данных и быстродействие |
| local_ssd 4Tb на ноде ex6 | | |
| |   SSD_storage 4Tb | разработка для которой критично быстродействие и не имеет значения сохранность данных |
|  hdd 64Tb | | |
| |   HDD1_qnap 22Tb | разработка и релизы для которых не критично быстродействие |
| |   HDD2_qnap 7Tb | клиентские на наших мощностях и gw |
| ____ | ____ | ____ | ____ |
|  local_hdd | | стараемся не использовать без необходимости |
| |   local | |
| |   local_lvm | |
| |   SAS_Storage | |
|  qnam_lvm | | старый nas забираем оттуда что ещё осталось на новый |



### Проекты

#### `ci/rc/prod-app-01` звено 5
- [Кабинет Партнера](https://gitlab.ksb.local/ksb/it_partner)
- [Онлайн Коснультант](https://gitlab.ksb.local/ksb/online_consult)
- [Сервис деск](https://gitlab.ksb.local/ksb/it_support) 
- [Вебинары и конференции](https://gitlab.ksb.local/ksb/webinar) 
- [Messworker](https://gitlab.ksb.local/ksb/messworker) 
- [Docplay](https://gitlab.ksb.local/ksb/docplay)

#### `ci/rc/prod-app-02` звено 4 
- [ИТ-Коннектор](https://gitlab.ksb.local/ksb/it_connector)
- [Альфа Таск](https://gitlab.ksb.local/ksb/alfatask) 

#### `ci/rc/prod-app-03` звено 3 
- [Сервис управления активами](https://gitlab.ksb.local/ksb/assetman)
- [Alfa-ID](https://gitlab.ksb.local/ksb/alfa-id)
- [Protection-sync](https://gitlab.ksb.local/ksb/protection-sync)

#### `ci/rc/prod-app-04` звено 1-2-3
- [Альфадок](https://gitlab.ksb.local/ksb/alfadoc)
- [Альфадиск](https://gitlab.ksb.local/ksb/disk) 
- [FileHopper](https://gitlab.ksb.local/ksb/filehopper)

#### `ci/rc/prod-app-05` звено 6 
- [Documentator](https://gitlab.ksb.local/ksb/documentator)
- [Kairos](https://gitlab.ksb.local/ksb/kairos)
- [Educator](https://gitlab.ksb.local/ksb/educator)
- [Postman](https://gitlab.ksb.local/ksb/postman)
- [Attestation](https://gitlab.ksb.local/ksb/attestation)


### DNS имена   
По шаблону `rc-*.npc-ksb.ru`, `documentator.ci5.ksb.local` - цифры в ci указываем в случае если сервис деплоится на несколько инстансов. 
Релизные `.ru` - через load balancer 50й, "нерелизные" `.local` через локальный nginx на вм с самим сервисом.
