#!/bin/sh
#version

tengine_ver=1.4.6
pid_file=/usr/local/data/nginx.pid
# environment
yum -y install pcre pcre-devel zlib zlib-devel

#install
temp_dir=$(mktemp -d)
clean(){
    rm -rf $temp_dir
}
trap clean EXIT INT

cd $temp_dir
if [ ! -f tengine-$tengine_ver.tar.gz ];then
    wget http://tengine.taobao.org/download/tengine-$tengine_ver.tar.gz
fi
tar zxvf tengine-$tengine_ver.tar.gz 
cd tengine-$tengine_ver
./configure --prefix=/usr/local/softwares/tengine --without-select_module --without-poll_module --without-procs --without-syslog --without-http_ssi_module --without-http_ssl_module --without-http_userid_module --without-http_footer_filter_module --without-http_access_module --without-http_auth_basic_module --without-http_autoindex_module --without-http_geo_module --without-http_map_module --without-http_split_clients_module --without-http_referer_module --without-http_rewrite_module --without-http_proxy_module --without-http_fastcgi_module --without-http_uwsgi_module --without-http_scgi_module --without-http_memcached_module --without-http_empty_gif_module --without-http_browser_module --without-http_upstream_check_module --without-http_upstream_least_conn_module --without-http_upstream_session_sticky_module --without-http_upstream_keepalive_module --without-http_upstream_ip_hash_module --without-http_upstream_consistent_hash_module --without-http_user_agent_module --without-http_stub_status_module --without-http --without-http-cache --without-mail_pop3_module --without-mail_imap_module --without-mail_smtp_module --without-pcre 
make install clean

mkdir -p /usr/local/logs/vm_tengine
#config
cat > /usr/local/softwares/tengine/conf/nginx.conf <<EOF

user  root root;

worker_processes 8;

error_log  /usr/local/logs/vm_tengine/error.log  crit;

pid        $pid_file;

worker_rlimit_nofile 65535;

events
{
  use epoll;
  worker_connections 65535;
}

http
{
  include       mime.types;
  default_type  application/octet-stream;

  server_names_hash_bucket_size 128;
  client_header_buffer_size 32k;
  large_client_header_buffers 4 32k;
  client_max_body_size 8m;
  
  limit_zone lzone $binary_remote_addr  20m;
  limit_req_zone  $binary_remote_addr  zone=rzone:20m   rate=200r/s; 

  sendfile on;
  tcp_nopush     on;

  keepalive_timeout 60;

  tcp_nodelay on;

  gzip on;
  gzip_min_length  1k;
  gzip_buffers     4 16k;
  gzip_http_version 1.0;
  gzip_comp_level 2;
  gzip_types       text/plain application/x-javascript text/css application/xml;
  gzip_vary on;

  include /usr/local/conf/vm_tengine/*.conf; 
}
	
EOF

cd /usr/local/conf
mkdir -p vm_tengine
if [ -f $pid_file ];then
    pid=$(cat $pid_file)
    kill -s SIGUSR2 $pid
fi

/usr/local/softwares/tengine/sbin/nginx

