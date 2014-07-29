<?php 
	include "./res/php/connectlocal.php";	//connect to db
 ?>

<!DOCTYPE HTML>

<html lang='en'>
	<head>
		<?php include "./res/php/header.php" ?>
		<title>Dashboard - Hurst Menu</title>
	</head>

	<body>
		<?php include "./res/php/navBar.php" ?>

		<div class="page">
	
			<div class="page-header">
				<h1>Hurst Menu <small>Dashboard</small></h1>
			</div>

		
			</div>

			<!-- link to view the menu for the whole week -->
			<a href="./viewMenu.php" style="clear: both; float: left; margin-left: 5px;">View whole week menu</a>			

			<?php include "./res/php/footer.php" ?>
		</div>
	</body>
</html>