<?php
# Can be used to upload files to the w dir! Dump this in the x dir to use it.
# Browse to the URI /x/upload.php
# GET requests are presented with a box to choose a file upload.
# A POST request is sent with the file, which is written to the w dir.
# If everything worked, the new file location (in the container, figure it out) is displayed
if(isset($_POST["submit"])) {
    $target_dir = "/var/www/web/w/";
    $max_file_size = 10000000;        

    // Check file size
    if ($_FILES["fileToUpload"]["size"] > $max_file_size) {
        echo "Too many bytes\n";
    }
    else {
        $target_file = $target_dir . basename($_FILES["fileToUpload"]["name"]);
        if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file)) {
            echo "Uploaded: " . $target_file ."\n";
        } else {
            echo "Error\n";
        }
    }
}
else {
    echo '<!DOCTYPE html>
    <html>
    <body>
    
    <form action="upload.php" method="post" enctype="multipart/form-data">
        <input type="file" name="fileToUpload" id="fileToUpload">
        <input type="submit" value="Upload" name="submit">
    </form>
    
    </body>
    </html>
';
}

?>