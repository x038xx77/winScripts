@echo off

REM Проверяем, что переданы все три параметра
if "%1"=="" goto :error
if "%2"=="" goto :error
if "%3"=="" goto :error

echo Parameters: Folder="%1", Extension="%2", Date="%3"
echo All files in folder %1 and its subfolders with extension .%2:
dir /s /b %1\*.%2

echo Data created        Extension       Name
echo -----------------------------------------

REM Преобразовываем дату в формат MM-DD-YYYY
for /f "delims=" %%d in ('powershell -Command "[datetime]::ParseExact('%3', 'dd.MM.yyyy', [System.Globalization.CultureInfo]::InvariantCulture).ToString('MM-dd-yyyy')"') do set "formattedDate=%%d"

REM Выводим информацию о каждом файле
for /r %1 %%i in (*.%2) do (
    set "fileName=%%~nxi"
    set "fileExt=%%~xi"
    set "fileDate=%%~ti"

    powershell.exe -Command "$fileDate='{0, -20}' -f '%%~ti'; $fileExt='{0, -15}' -f '%%~xi'; $fileName='{0, -30}' -f '%%~nxi'; Write-Host \"$fileDate$fileExt$fileName\""

    REM Проверяем, если дата создания файла меньше указанной даты
    if !fileDate! lss !formattedDate! (
        REM Удаляем файл, если условие выполняется
        del "%%i"
        echo "%%i" deleted succefull
    )
)
