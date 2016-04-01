<?php include 'config.php' ?>
<html>
    <?php include 'head.php' ?>
    <body>
        <?php include 'header.php' ?>
        <?php include 'banner.php' ?>
        <div class="content">
       <form name="costmodel" id="costmodel" action="result.php" method="POST" enctype="multipart/form-data" >
            <?php
            $extension; //xml
            $completeName; //example.xml, ...
            $fileName; //example, ...
            $realName; ///tmp/web/Arithmetic.class

            if ( $_GET["name"] && $_GET["dir"]) { //check if choose an example
                $completeName = $_GET["name"];
                $realName = $_GET["dir"].$completeName;
                $upload = false;
            }
            elseif ( $_FILES['upload']['tmp_name'] != "" ) {
                $completeName = $_FILES['upload']['name'];
                $realName = $_FILES['upload']['tmp_name'];
                $upload = true;
            }
            else
                die("Not valid XML file");

	    $pathParts = pathinfo($completeName);
	    $fileName = $pathParts['filename'];
            echo "<input type='hidden' name = 'fileName' value = $fileName>";
            $extension = strrpos($completeName,".");
            if($extension)
                $extension = substr($completeName,$extension+1);
            if(!file_exists(TMP_JHSYS))
               mkdir(TMP_JHSYS);
            if(!file_exists(TMP_WEB))
                mkdir(TMP_WEB);
            if ($extension == 'xml'){
                    shell_exec('chmod -R 777 '.TMP_WEB.'; rm -rf '.TMP_WEB.'.*');
                    $target = TMP_WEB . basename($completeName);
                    if($upload) {
			//echo "<br>UPLOAD<br>tmp_name:"; var_dump($_FILES['upload']['tmp_name']);
			//echo "<br>target:"; var_dump($target);
                        if(!move_uploaded_file($_FILES['upload']['tmp_name'], $target)) {
                            die("The $completeName coud not be uploaded, try again!");
			} else {
			    shell_exec('chmod -R 777 '.TMP_WEB);	
			    $realName = $target;
			}
			//echo "<br>realName:"; var_dump($realName);
                    }
                    else {
                        if(!copy($_GET["dir"].$_GET["name"], $target))
                            die("The $completeName coud not be copied, try again!");
                        else {
                            shell_exec('chmod 777 '.$target);
			    $realName = $target;
			}
                    }
		    echo "<input type='hidden' name = 'realName' value = $realName>";
	    }
            else
                die("$completeName is an invalid file type ! <br> It must be an XML file.");
            ?>

            <pre>
                <?php
	            echo "<br>";
                    echo "<h3>XML File contents:</h3>";
	            echo "<br>";
                    if(!$file_contents = @file_get_contents("$realName"))
                        $result = "File $realName not found.";
                    else
                        $result=htmlentities($file_contents);
                    echo $result;
                ?>
            </pre>

            <p>

	    <input type='submit' name='submit' value='Run jHSys'
       </form>


	    
            <?php include 'banner.php' ?>
            <?php include 'footer.php' ?>
        </div>
    </body>
</html>
