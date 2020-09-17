# (c) Ferhat ARDA <farda@ferhatarda.com>

Write-Host "get files path....";
$exefiles = Get-ChildItem -Path "C:\" -recurse -file | select fullname,LastAccessTime,CreationTime,LastWriteTime,Directory

[string[]]$virus_hashes = Get-Content -path virus_hash.txt
Write-Host "loaded virus hash....";

Add-Content Report.txt "HASH - Enfected File - LastAccessTime - CreationTime - ModifyTime"
Write-Host "Starting the scan...."

foreach ($exefile in $exefiles)
{
    $hash_md5 = (Get-FileHash -Path $exefile.FullName -Algorithm MD5 -ErrorAction Continue).hash
    Write-Host $exefile.FullName " - " $hash_md5
    if ($virus_hashes -contains $hash_md5)
    {
        $satir = $hash_md5 + " - " + $exefile.FullName + " - " + $exefile.LastAccessTime + " - " + $exefile.CreationTime + " - " + $exefile.LastWriteTime
        Add-Content Report.txt -Value $satir
        Write-Host $exefile.FullName " - " $hash_md5 " - Please check it!"
    } elseif ($hash_md5 -eq '')
    {
	$not_check = $exefile.FullName + " - unchecked"
	Add-Content Report.txt -Value $not_check
    }
    #Write-host $exefile.Directory
    

} 
Write-Host "finished the scan....";

