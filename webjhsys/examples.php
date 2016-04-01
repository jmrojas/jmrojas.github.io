<?php include 'config.php'?>
<html>
    <?php include 'head.php' ?>
    <body>
        <?php include 'header.php' ?>
        <?php include 'banner.php'?>
        <div class="content">
            <form name="examples" action="" method="POST" enctype="multipart/form-data">
                <p>
                    <b>
                        Step 1. Use "Select" to choose an example from the list. Also for every
                        example, "Show java" displays its source code and "Show bytecode" shows
                        its bytecode.
                        <br />
                    </b>
                </p>
                <h3>List of examples in PET's directory </h3>
                <?php
                function isClassFile($file) {
                    return substr_count($file,'.class') == 1;
                }
                function isJavaFile($file){
                    return substr_count($file,'.java') == 1;
                }

                function linkToStep1($file,$text,$dir) {
                    echo "<a href=\"step1.php?dir=$dir&name=$file\"> $text </a>&nbsp;";
                }

                function linkToSrc($file,$text,$dir) {
                    echo "show <a target=\"_new\" href=\"show_src_file.php?path=$dir$file\">$text</a>";
                }

                function linkToBytecode($file,$text,$dir) {
                    echo "<a target=\"_new\" href=\"show_bytecode.php?path=$dir$file\">$text</a>";
                }

                function showClassFile($path,$file) {
                    echo "<li>";
                    linkToStep1($file,'Select',$path);
                    echo "     $file   ";
                    $fileName=remove_extension($file);
                    echo "<small>&nbsp;";
                    linkToBytecode($fileName,'Bytecode',$path);
                    if (file_exists($path.$fileName.'.java')) {
                        echo "&nbsp;  ||  &nbsp;";
                        linkToSrc($fileName,'Java',$path);
                    }
                    echo "</small>";
                    echo "</li>";
                }
                
                function showJavaFile($path,$file) {
                    echo "<li>";
                    linkToStep1($file,'Select',$path);
                    echo "     $file   ";
                    $fileName=remove_extension($file);
                    echo "<small>&nbsp;";
                    linkToSrc($fileName,'Java',$path);
                    if (file_exists($path.$fileName.'.class')) {
                        echo "&nbsp;  ||  &nbsp;";
                        linkToBytecode($fileName,'Bytecode',$path);
                    }
                    echo "</small>";
                    echo "</li>";
                }

                function showExamples($path, $text) {
                    echo "<ul>";
                    echo "<li>$text<br />";
                    if($path{strlen($path)-1} != '/')
                        $path = $path.'/';
                    $examples=@file_get_contents($path.'Showexamples');
                    if($examples) {
                        $directories = array();
                        $files = array();
                        foreach(split("\n",rtrim($examples)) as $file) {
                            if(!file_exists($path.$file))
                                continue;
                            if(is_dir($path.$file)) {
                                if($file != ".")
                                    array_push($directories,$file);
                            }
                            else
                                array_push($files,$file);
                        }
                        if(count($directories) || count($files)) {
                            foreach($files as $file) {
                                echo "<ul>";
                                if(isClassFile($file))
                                    showClassFile($path, $file);
                                elseif(isJavaFile($file))
                                    showJavaFile($path, $file);
                                echo "</ul>";
                            }
                            foreach($directories as $directory)
                                showExamples("$path$directory", $directory);
                        }
                    }
                    echo "</li>";
                    echo "</ul>";
                }


                $folder = $_GET["folder"];
                $dir = $_GET["dir"];
                if(!$dir)
                    $dir = EXAMPLES;
                    
                $path = $dir.$folder; 
                
                showExamples($path,$folder);
                ?>
            </form>
            <?php include 'banner.php' ?>
            <?php include 'footer.php' ?>
        </div>
    </body>
</html>

