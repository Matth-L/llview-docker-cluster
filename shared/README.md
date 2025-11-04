# Shared directory

/!\ All the directory aren't shared to all the service in the docker-compose. The path of the mounted directory will most likely change in the docker img, .e.g `shared/JURI` -> `/var/www/html` in the `web_server` docker image.


```
shared/
├── 📁 compute
├── 📁 JURI
├── 📁 llview_install
├── 📁 remote_server
└── 📁 server_web
```

- `/compute`, is mounted in all the compute node. .ie `c1`,`c2`,`c3`. It's mounted as is, therefore, the location in the compute node is still

  `/shared/compute`. This location contains all the script that the users will be able to launch.
- `JURI`, it's a `git clone` of https://apps.fz-juelich.de/jsc/llview/docu/install/juri_install/ , no change were made in this folder except `login.php` that is located in `/shared/llview_install/login.php`. A softlink is created to replace `login.php` of the JURI repo with mine, that automatically logs us a `userA`. This folder is mounted in the Apache web server as `/var/www/html`

- `/remote_server` is a shared file system between the remote part and the server part. It's analog to the `${LLVIEW_SHARED}` of the `.llview_remote_rc`.

- `/server_web` is a shared file system between the server part and the web part. It's analog to the `${LLVIEW_WEB_DATA}` of the `.llview_server_rc`. This folder contains a `/data`, this folder is mounted in the web server in `/var/www/html/data`. This is made to prevent the use of the step `transferreport`. This step makes an Rsync of the `/data` folder located in remote to the web server.

- `llview_install` is a git clone of LLView. The `configs` folder inside contains all the modifications made for this proof of concept to work.
