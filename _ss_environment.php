<?php

/*---------------------------------------------------------------------------------
 * Set environment type
 *
 * Options: dev, test, live
 *--------------------------------------------------------------------------------*/
define('SS_ENVIRONMENT_TYPE', 'dev');


/*---------------------------------------------------------------------------------
 * Setup database details
 *--------------------------------------------------------------------------------*/
define('SS_DATABASE_SERVER', 'localhost');
define('SS_DATABASE_USERNAME', 'root');
define('SS_DATABASE_PASSWORD', 'rootpass');
define('SS_DATABASE_NAME', 'silverstripe');


/*---------------------------------------------------------------------------------
 * Default CMS User
 *--------------------------------------------------------------------------------*/
define('SS_DEFAULT_ADMIN_USERNAME', 'admin');
define('SS_DEFAULT_ADMIN_PASSWORD', 'password');

// Protect entire site by basic auth when set to true
define('SS_USE_BASIC_AUTH', false);


/*---------------------------------------------------------------------------------
 * Email
 *
 * This ensures emails are only sent to you and not actual email addresses.
 *--------------------------------------------------------------------------------*/
define('SS_SEND_ALL_EMAILS_TO', 'to@local.dev');
define('SS_SEND_ALL_EMAILS_FROM', 'from@local.dev');


