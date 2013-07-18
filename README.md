Tools
================================

一些软件和配置的快捷安装脚本

config.sh
---------------------------------

从变量配置文件中导入一批变量成全局变量。

变量配置文件格式是：

```bash
k1=v1
k2=v2
...
```

使用方式：

```bash
# 用法
source config.sh /path/to/var-config-file.conf [var_prefix]
# 注意要使用source命令来导入，这样全局变量才会在当前Shell中生效！

# 示例
source config.sh foo.conf AAA_
# foo.conf的内容是"a=b"时，导入全局变量"AAA_a=b"
```
