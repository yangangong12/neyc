@echo off
setlocal

rem 设置起始编号
set num=1
set "format=YAZJZ%07d"

rem 设置要遍历的根目录
set "rootDir=G:\1\1"

rem 检查根目录是否存在
if not exist "%rootDir%" (
    echo 指定的根目录不存在。
    pause
    exit /b
)

rem 打开 1.txt 文件准备写入 SQL 命令，如果文件已存在则先清空
>1.txt echo.

rem 遍历目录树
for /r "%rootDir%" %%a in (*) do (
    rem 判断是否是文件
    if exist "%%a" (
        set "address=%%a"
        rem 获取文件所在目录路径
        set "dirPath=%%~dpa"
        rem 获取科目名称（根目录的名称）
        for %%b in ("%rootDir%") do set "kemu=%%~nxb"
        rem 获取年级和上下册信息
        for /f "delims=" %%c in ("!dirPath:%rootDir%\=!") do (
            set "dirParts=%%c"
            for %%d in ("!dirParts:\=!") do (
                if "%%d"=="上" (
                    set "kind=1"
                ) else if "%%d"=="下" (
                    set "kind=2"
                ) else if "%%d" like "%%年级" (
                    set "grade=%%d"
                    set "grade=!grade:年级=!"
                )
            )
        )
        set "name=%%~nxa"
        set "allb=%format:~0,-3%!num!"

        rem 构建 SQL 插入命令并写入 1.txt 文件
        echo INSERT INTO yangzjz (name, grade, kemu, kind, allb, address) VALUES ('!name!',!grade!, '!kemu!',!kind!, '!allb!', '!address!')>>1.txt
        set /a num+=1
    )
)

rem 暂停窗口，防止自动关闭
pause