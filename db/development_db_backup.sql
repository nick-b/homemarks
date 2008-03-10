SET NAMES latin1;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE `bookmarks` (
  `id` int(11) NOT NULL auto_increment,
  `box_id` int(11) NOT NULL,
  `url` varchar(1024) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `visited_at` datetime default NULL,
  `position` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `indx_bookmarks_id` (`id`),
  KEY `fki_bookmarks_box_id` (`box_id`),
  CONSTRAINT `fkey_bookmarks_box_id` FOREIGN KEY (`box_id`) REFERENCES `boxes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into `bookmarks` values('4','49','http://admin/crayola.html','Crayola Color Swatches','2006-03-18 23:17:07','2006-05-29 00:17:07','3'),
 ('6','2','http://admin/test.php\n','PHP Test Page\n','2006-05-01 00:17:07','2006-06-30 00:17:07','4'),
 ('7','3','http://i.decipher.com/dTools/dOrders/SearchUtilities/SearchCustomer.aspx','i.Decipher CusSearch','2006-03-19 23:17:07','2006-05-08 00:17:07','3'),
 ('8','3','http://decipherstore.fanhq.com/dAdmin/default.asp','dAdmin at DecipherStore','2006-03-11 23:17:07','2006-07-28 00:17:07','4'),
 ('9','3','http://stats.pinn.net/decipher/','Pinn.net Traffic Stats','2006-04-04 00:17:07','2006-07-13 00:17:07','5'),
 ('10','2','man:crap\n','Bwana Man Search\n','2006-02-06 23:17:07','2006-05-15 00:17:07','1'),
 ('11','2','man:\n','Bwana Man Index\n','2006-04-30 00:17:07','2006-07-22 00:17:07','2'),
 ('12','2','http://localhost:10000/\n','Webmin\n','2006-02-19 23:17:07','2006-05-22 00:17:07','3'),
 ('14','3','http://i.decipher.com/\n','i.Decipher Homepage\n','2006-02-06 23:17:07','2006-05-28 00:17:07','2'),
 ('15','3','http://fanhq.com/\n','FanHQ.com\n','2006-03-17 23:17:07','2006-06-22 00:17:07','1'),
 ('19','11','http://alexmaccaw.no-ip.info/eribium/?p=49','WebDAV on RAILS','2006-04-27 00:17:07','2006-07-13 00:17:07','6'),
 ('20','11','http://alexmaccaw.no-ip.info/eribium/?page_id=2','Eribium','2006-02-10 23:17:07','2006-05-12 00:17:07','7'),
 ('21','11','http://www.spread-cms.org/','Spread','2006-04-22 00:17:07','2006-07-25 00:17:07','8'),
 ('22','12','http://api.rubyonrails.com/','Ref - RoR API','2006-02-15 23:17:07','2006-07-01 00:17:07','3'),
 ('23','12','http://www.ruby-doc.org/core/','Ref - Ruby Core','2006-03-28 23:17:07','2006-07-09 00:17:07','2'),
 ('24','12','http://www.google.com/search?hl=en&lr=&client=safari&rls=en&as_qdr=all&q=bla+site%3Aapi.rubyonrails.com&btnG=Search','Ref - RoR API (GoogSrch)','2006-02-28 23:17:07','2006-07-05 00:17:07','4'),
 ('30','49','http://admin/fonts.html','Font Swatches','2006-04-16 00:17:07','2006-06-18 00:17:07','4'),
 ('31','12','http://www.rubyonrails.org/','RoR - Main Site','2006-02-04 23:17:07','2006-06-25 00:17:07','1'),
 ('32','11','http://svn.techno-weenie.net/projects/mephisto/','Mephisto','2006-02-01 23:17:07','2006-05-25 00:17:07','3'),
 ('33','11','http://www.radiantcms.com/','RadiantCMS','2006-04-29 00:17:07','2006-07-17 00:17:07','5'),
 ('34','11','http://typosphere.org/','TypoSphere','2006-02-26 23:17:07','2006-05-22 00:17:07','4'),
 ('43','20','http://www.mochikit.com/','Mochikit','2006-03-06 23:17:07','2006-06-13 00:17:07','3'),
 ('44','21','http://fora.pragprog.com/rails-recipes/discuss-the-book','RAILs Recipes - Board','2006-04-20 00:17:07','2006-07-04 00:17:07','4'),
 ('45','21','http://books.pragprog.com/titles/fr_rr/errata','RAILs Recipes - Errata ','2006-02-27 23:17:07','2006-05-26 00:17:07','3'),
 ('48','20','http://jquery.com/','jQuery','2006-03-09 23:17:07','2006-05-28 00:17:07','2'),
 ('50','20','http://moofx.mad4milk.net/','Moo.fx','2006-03-16 23:17:07','2006-07-01 00:17:07','1'),
 ('59','27','http://wiki.script.aculo.us/scriptaculous/show/Sortables','Controls - Sortables','2006-08-09 21:04:33',null,'7'),
 ('60','27','http://wiki.script.aculo.us/scriptaculous/show/Autocompletion','Controls - Autocompletion','2006-08-09 21:12:49',null,'8'),
 ('61','27','http://wiki.script.aculo.us/scriptaculous/show/Ajax.InPlaceEditor','Controls - InPlaceEditor','2006-08-09 21:12:56',null,'9'),
 ('62','27','http://wiki.script.aculo.us/scriptaculous/show/Ajax.In+Place+Collection+Editor','Controls - InPlaceClct.Edt.','2006-08-09 21:12:59',null,'10'),
 ('63','27','http://wiki.script.aculo.us/scriptaculous/show/Droppables','Controls - Droppables','2006-08-09 21:13:22',null,'6'),
 ('64','27','http://wiki.script.aculo.us/scriptaculous/show/Draggables','Controls - Draggables','2006-08-09 21:14:15',null,'5'),
 ('65','27','http://wiki.script.aculo.us/scriptaculous/show/VisualEffects','Effects - Visual Effects','2006-08-09 21:14:59',null,'4'),
 ('66','27','http://admin/scriptaculous-js-1.6.4/test/run_functional_tests.html','Good... Local 1.6.4 Tests','2006-08-09 22:29:46',null,'3'),
 ('67','27','http://admin/scriptaculous-js-1.6.4/','Good... Local 1.6.4','2006-08-09 22:30:23',null,'2'),
 ('68','27','http://wiki.script.aculo.us/scriptaculous/tags/','Good... All Pages','2006-08-09 22:32:51',null,'1'),
 ('77','27','http://wiki.script.aculo.us/scriptaculous/show/Builder','Utilities - Builder','2006-08-09 23:15:21',null,'11'),
 ('78','26','http://prototype-window.xilinus.com/','Popup Window Class','2006-08-09 23:16:02',null,'5'),
 ('80','26','http://www.sergiopereira.com/articles/prototype.js.html','Developer Notes','2006-08-09 23:16:06',null,'4'),
 ('82','26','http://admin/prototype.pdf','Prototype Helper Chrt.(pdf)','2006-08-09 23:16:09',null,'3'),
 ('83','26','http://admin/prototype1440w.png','Prototype Helper Chrt.','2006-08-09 23:16:10',null,'2'),
 ('84','26','http://prototype.conio.net/','Prototype','2006-08-09 23:16:11',null,'1'),
 ('85','30','http://pricing.dev.decisiv.net/','pricing.dev.decisiv.net','2006-08-09 23:19:46',null,'4'),
 ('86','48','http://volvo.asist.decisiv.net/','Live - Volvo Asist','2006-08-09 23:19:47',null,'1'),
 ('87','129','http://mack.asist.decisiv.net/','Live - Mack Asist','2006-08-09 23:19:48',null,'1'),
 ('88','128','http://international.decisiv.net/','Live - International DES','2006-08-09 23:19:49',null,'1'),
 ('92','30','http://portal.dev.decisiv.net/','portal.dev.decisiv.net','2006-08-10 09:49:30',null,'3'),
 ('93','128','http://international.decisiv.net/','  dadminABCD / INT4002','2006-08-10 12:37:03',null,'2'),
 ('94','129','http://mack.asist.decisiv.net/','  dadmindemo / MCK4002','2006-08-10 12:37:11',null,'2'),
 ('96','31','http://opensource.agileevolved.com/trac/wiki/UnobtrusiveJavascript','Agile Evolved - UoJS','2006-08-10 14:05:39',null,'3'),
 ('97','31','http://encytemedia.com/event-selectors/','CSS event:selectors','2006-08-10 14:05:39',null,'2'),
 ('98','31','http://bennolan.com/behaviour/','Behaviour - Ben Nolan','2006-08-10 14:05:40',null,'1'),
 ('100','49','http://admin/miniicons/','Mini Icons','2006-08-14 22:57:06',null,'2'),
 ('101','32','http://adm8.com/admin','Local - AdM8 Admin','2006-08-18 21:11:25',null,'3'),
 ('102','20','http://encytemedia.com/blog/articles/2005/12/01/rico-rounded-corners-without-all-of-rico','Rounded Corners','2006-08-19 11:23:11',null,'4'),
 ('103','128','http://int.staging.decisiv.net/','int.staging.decisiv.net','2006-08-29 12:11:47',null,'3'),
 ('104','32','http://adm8.actionmoniker.com/','Stage- AdM8 Admin','2006-09-02 10:51:33',null,'2'),
 ('105','33','http://www.google.com/search?hl=en&lr=&q=parent+http%3A%2F%2Fdevguru.com%2Ftechnologies%2Fxml_dom%2F&btnG=Search','DevGuru XML DOM (find)','2006-09-05 11:52:44',null,'7'),
 ('106','33','http://www.google.com/search?hl=en&lr=&as_qdr=all&q=parent+site%3Ahttp%3A%2F%2Fdevguru.com%2Ftechnologies%2Fjavascript%2F&btnG=Search','DevGuru JS Ref. (find)','2006-09-05 11:52:45',null,'5'),
 ('107','32','http://actionmoniker.grouphub.com/','Basecamp','2006-09-07 17:34:29',null,'1'),
 ('110','11','http://svn.techno-weenie.net/projects/beast/','Beast Forum (svn)','2006-09-13 13:48:50',null,'2'),
 ('111','11','http://beast.caboo.se/','Beast Forum','2006-09-13 13:48:51',null,'1'),
 ('112','129','http://mack.staging.decisiv.net/','mack.staging.decisiv.net','2006-09-19 14:30:56',null,'3'),
 ('113','30','http://mack.staging.decisiv.net/','admin / DCV4002','2006-09-19 14:32:20',null,'5'),
 ('114','33','http://devguru.com/technologies/xml_dom/home.asp','DevGuru XML DOM','2006-09-20 13:01:59',null,'6'),
 ('115','33','http://devguru.com/technologies/javascript/home.asp','DevGuru JS Ref.','2006-09-20 13:02:00',null,'4'),
 ('116','34','http://manuals.rubyonrails.com/read/book/17','Capistrano Manual','2006-10-06 19:58:00',null,'3'),
 ('117','34','http://dizzy.co.uk/cheatsheets/capistrano.pdf','Cheat Sheet (pdf)','2006-10-06 19:58:01',null,'2'),
 ('118','34','http://groups.google.com/group/capistrano','Mailing List','2006-10-06 19:59:58',null,'1'),
 ('161','48','http://vistaadvisor.volvo.decisiv.net/','VistaAdvisor (Volvo)','2006-10-23 09:48:53',null,'3'),
 ('162','48','http://moodle.org/','Moodle','2006-10-23 09:49:19',null,'4'),
 ('164','33','http://www.quirksmode.org/resources.html','QuirskMode.org','2006-10-26 17:25:59',null,'1'),
 ('165','33','http://www.quirksmode.org/dom/compatibility.html','QuirskMode.org DOM Cmp','2006-10-26 17:26:26',null,'3'),
 ('166','33','http://www.google.com/search?as_q=document&num=10&hl=en&client=safari&rls=en&btnG=Google+Search&as_epq=&as_oq=&as_eq=&lr=&as_ft=i&as_filetype=&as_qdr=all&as_nlo=&as_nhi=&as_occt=any&as_dt=i&as_sitesearch=http%3A%2F%2Fwww.quirksmode.org%2F&as_rights=&safe=images','QuirksMode.org - (find)','2006-10-26 18:42:05',null,'2'),
 ('168','49','http://admin/doctypes/','Misc DOCTYPEs','2006-10-26 21:00:43',null,'1'),
 ('191','21','http://alumni.pragmaticstudio.com/users/128','Pragmatic Studio Yearbook','2006-11-01 20:17:58',null,'2'),
 ('192','21','http://pragmaticprogrammer.com/','The Pragmatic Programmer','2006-11-01 20:19:12',null,'1'),
 ('215','48','http://volvo.composite.decisiv.net/','Volvo Composite Portal','2006-11-14 19:10:28',null,'2'),
 ('222','30','http://maps.google.com/maps?f=q&hl=en&q=decisiv+inc&sll=37.639093,-77.636009&sspn=0.023109,0.033646&ie=UTF8&z=13&ll=37.669826,-77.609653&spn=0.092397,0.134583&om=1&iwloc=A','Decisiv inc - Google Maps','2006-11-17 11:48:39',null,'2'),
 ('483','30','http://www.decisiv.com/','Decisiv Site','2006-11-27 10:01:08',null,'1'),
 ('484','128','http://servicepartner.decisiv.net/','servicepartner.decisiv.net','2006-11-27 10:07:21',null,'4'),
 ('485','48','http://volvo.staging.decisiv.net/','volvo.staging.decisiv.net','2006-11-27 10:10:17',null,'5'),
 ('487','126','http://mongrel.rubyforge.org/','Mongrel Home','2006-11-27 13:29:52',null,'4'),
 ('488','126','http://www.lighttpd.net/','Lighty Home','2006-11-27 13:50:32',null,'2'),
 ('489','126','http://blog.lighttpd.net/articles/tag/mod_proxy_core','Lighty (mod_proxy_core)','2006-11-27 14:04:12',null,'3'),
 ('491','126','http://blog.codahale.com/2006/06/19/time-for-a-grown-up-server-rails-mongrel-apache-capistrano-and-you/','Mongrel, Apache, Capistrano and You','2006-11-27 14:57:03',null,'5'),
 ('492','12','http://weblog.rubyonrails.org/2006/11/26/1-2-new-in-activerecord','New in ActiveRecord','2006-11-27 15:30:33',null,'7'),
 ('493','12','http://weblog.rubyonrails.org/2006/11/26/1-2-new-in-actionpack','New in Action Pack','2006-11-27 15:30:55',null,'6'),
 ('494','12','http://weblog.rubyonrails.org/2006/11/26/1-2-new-in-activesupport','New in Active Support','2006-11-27 15:31:02',null,'5'),
 ('495','126','http://www.macports.org/','MacPorts','2006-11-29 21:09:49',null,'1');

CREATE TABLE `boxes` (
  `id` int(11) NOT NULL auto_increment,
  `column_id` int(11) NOT NULL,
  `title` varchar(64) NOT NULL default 'Rename Me...',
  `style` varchar(16) default NULL,
  `collapsed` tinyint(1) NOT NULL default '0',
  `position` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `indx_boxes_id` (`id`),
  KEY `fki_boxes_column_id` (`column_id`),
  CONSTRAINT `fkey_boxes_column_id` FOREIGN KEY (`column_id`) REFERENCES `columns` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into `boxes` values('2','9','Administration','white','1','1'),
 ('3','9','Decipher','black','0','4'),
 ('11','2','RAILS CntMgtSys.','limeade','1','3'),
 ('12','2','RAILs & Ref.','red','0','1'),
 ('20','7','JavaScript Other','yellow_green','1','4'),
 ('21','2','Prag Programmer','red','0','2'),
 ('26','7','Prototype','orange','1','1'),
 ('27','7','Script.aculo.us','spring_green','1','2'),
 ('30','1','Decisiv Dev.','black','0','1'),
 ('31','7','Behaviour JS','cerulian','0','5'),
 ('32','9','AdM8 Project','violet','1','3'),
 ('33','7','JavaScript Resc.','yellow_green','1','3'),
 ('34','8','Capistrano','salmon','0','1'),
 ('48','1','Decisiv - Volvo','aqua','0','4'),
 ('49','9','Miscellanous Dev.',null,'0','2'),
 ('126','8','Mongrel, Apache, & Lighttpd Servers','salmon','0','2'),
 ('128','1','Decisiv - Intnl.','bisque','0','2'),
 ('129','1','Decisiv - Mack','white','0','3');

CREATE TABLE `columns` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `position` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `indx_columns_id` (`id`),
  KEY `fki_columns_user_id` (`user_id`),
  CONSTRAINT `fkey_columns_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into `columns` values('1','1','1'),
 ('2','1','5'),
 ('7','1','3'),
 ('8','1','4'),
 ('9','1','2');

CREATE TABLE `inboxes` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `indx_inboxes_id` (`id`),
  KEY `fki_inboxes_user_id` (`user_id`),
  CONSTRAINT `fkey_inboxes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into `inboxes` values('1','1'),
 ('2','6');

CREATE TABLE `inboxmarks` (
  `id` int(11) NOT NULL auto_increment,
  `inbox_id` int(11) NOT NULL,
  `url` varchar(1024) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `visited_at` datetime default NULL,
  `position` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `indx_inboxmarks_id` (`id`),
  KEY `fki_inboxmarks_inbox_id` (`inbox_id`),
  CONSTRAINT `fkey_inboxmarks_inbox_id` FOREIGN KEY (`inbox_id`) REFERENCES `inboxes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into `inboxmarks` values('62','1','http://labb.dev.mammon.se/swfupload/','SWFUpload beta','2006-11-16 10:57:46',null,'8'),
 ('68','2','','Test Boxmark 3','2006-11-23 21:43:38',null,'4'),
 ('69','2','','Test2 Boxmark 6','2006-10-31 20:59:05',null,'3'),
 ('70','2','','Test Boxmark 4','2006-11-23 21:43:38',null,'2'),
 ('71','2','','Test4 Boxmark ','2006-11-23 21:45:57',null,'1'),
 ('72','1','http://www.csscreator.com/','CSSCreator  ','2006-11-24 14:03:58',null,'5'),
 ('74','1','http://wiki.script.aculo.us/scriptaculous/show/Versions','Versions in Scriptaculous','2006-11-24 14:16:40',null,'4'),
 ('76','1','http://www.apress.com/book/bookDisplay.html?bID=10178','Beginning Ruby on Rails E-Commerce: From Novice to Professional','2006-11-26 14:35:38',null,'3'),
 ('77','1','http://topfunky.com/clients/peepcode/REST-cheatsheet.pdf','RESTful Cheatsheet','2006-11-26 14:40:23',null,'6'),
 ('78','1','http://www.newegg.com/product/product.asp?item=N82E16833122141','NETGEAR GS608 10/100/1000Mbps Switch - Retail at Newegg.com','2006-11-27 14:27:41',null,'2'),
 ('86','1','http://dev.rubyonrails.org/svn/rails/spinoffs/scriptaculous/src/','Revision 5623: /spinoffs/scriptaculous/src','2006-11-24 14:45:34',null,'9'),
 ('87','1','http://www.ozgrid.com/Excel/PivotTables/ExCreatePiv1.htm','Pivot Table Reports 101','2006-10-25 17:52:42',null,'10'),
 ('88','1','http://www.futhark.ch/mysql/106.html','Dynamic Crosstabs using MySQL SPs','2006-10-26 19:15:48',null,'7'),
 ('89','1','http://maczot.com/discuss/?p=251','macZOT! » TaskTime 4','2006-11-29 00:26:41',null,'1');

CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

insert into `schema_info` values('6');

CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `sessid` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `indx_sessions_sessid` (`sessid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into `sessions` values('29','30e4669bf6c0d4695dff27e685960445','BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNo\nSGFzaHsABjoKQHVzZWR7AA==\n','2006-11-06 12:26:22'),
 ('30','82272bf9a1aa1e6a8e88bbf5ea900bfd','BAh7CDoOcmV0dXJuX3RvIgovaG9tZSIKZmxhc2hJQzonQWN0aW9uQ29udHJv\nbGxlcjo6Rmxhc2g6OkZsYXNoSGFzaHsABjoKQHVzZWR7ADoJdXNlcmkG\n','2006-11-29 21:09:49'),
 ('31','5bf3a780754ef33d307e39715fcf6d1e','BAh7BzoOcmV0dXJuX3RvIgYvIgpmbGFzaElDOidBY3Rpb25Db250cm9sbGVy\nOjpGbGFzaDo6Rmxhc2hIYXNoewAGOgpAdXNlZHsA\n','2006-11-06 12:49:06'),
 ('32','63537abd4e94f19207e7bc0520cdbda1','BAh7BzoOcmV0dXJuX3RvIgYvIgpmbGFzaElDOidBY3Rpb25Db250cm9sbGVy\nOjpGbGFzaDo6Rmxhc2hIYXNoewAGOgpAdXNlZHsA\n','2006-11-06 13:28:23'),
 ('33','5410288a1fc8a238241ac8f75e7cac11','BAh7CDoOcmV0dXJuX3RvIgYvOgl1c2VyaQYiCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n','2006-11-07 14:40:59'),
 ('34','2a2da6d94a9aa83155edf8bcfb86d36e','BAh7CDoJdXNlcmkGOg5yZXR1cm5fdG8iBi8iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n','2006-11-16 15:28:07'),
 ('35','3c66e344af9fe6f2a11e1ee31dd8ac4c','BAh7CDoJdXNlcmkGOg5yZXR1cm5fdG8iBi8iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n','2006-11-17 09:20:40'),
 ('36','9cae52b9f948b8fa3268edc0983af567','BAh7BzoOcmV0dXJuX3RvIgYvIgpmbGFzaElDOidBY3Rpb25Db250cm9sbGVy\nOjpGbGFzaDo6Rmxhc2hIYXNoewAGOgpAdXNlZHsA\n','2006-11-17 09:49:29'),
 ('37','86ab5b24f8c807cc48468b3e38ceb79f','BAh7CDoJdXNlcmkGOg5yZXR1cm5fdG8iBi8iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n','2006-11-23 12:39:51'),
 ('38','93a6b2d8b8a587913819397d861e4efb','BAh7CDoOcmV0dXJuX3RvIgYvOgl1c2VyaQYiCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n','2006-11-29 18:47:48'),
 ('39','acb555ebbe9a76f98d0368181663b3c2','BAh7CDoJdXNlcmkLOg5yZXR1cm5fdG8iBi8iCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n','2006-11-24 12:02:37'),
 ('40','ed9839e6a2280f9d479406d07986c34e','BAh7CDoOcmV0dXJuX3RvIgYvOgl1c2VyaQsiCmZsYXNoSUM6J0FjdGlvbkNv\nbnRyb2xsZXI6OkZsYXNoOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n','2006-11-24 15:21:05');

CREATE TABLE `trashboxes` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `indx_trashboxes_id` (`id`),
  KEY `fki_trashboxes_user_id` (`user_id`),
  CONSTRAINT `fkey_trashboxes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into `trashboxes` values('3','1'),
 ('2','6');

CREATE TABLE `trashboxmarks` (
  `id` int(11) NOT NULL auto_increment,
  `trashbox_id` int(11) NOT NULL,
  `url` varchar(1024) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL,
  `visited_at` datetime default NULL,
  `position` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `indx_trashmarks_id` (`id`),
  KEY `fki_trashmarks_trashbox_id` (`trashbox_id`),
  CONSTRAINT `fkey_trashboxmarks_trashbox_id` FOREIGN KEY (`trashbox_id`) REFERENCES `trashboxes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into `trashboxmarks` values('171','3','','','2006-11-25 09:55:07',null,'30'),
 ('172','3','http://localhost:3000/','Local - RoR','2006-04-24 00:17:07','2006-07-03 00:17:07','29'),
 ('173','3','http://kash.com/','Local - Kash.com','2006-03-26 23:17:07','2006-07-05 00:17:07','28'),
 ('174','3','http://www.crummy.com/writing/RubyCookbook/','Bk - Ruby Cookbook Code','2006-10-17 12:04:35',null,'27'),
 ('175','3','http://www.oreilly.com/catalog/rubyckbk/','Bk - Ruby Cookbook','2006-10-17 12:04:12',null,'26'),
 ('176','3','http://www.ruby-forum.com/forum/3','Ref - RoR List (RbForum)','2006-03-12 23:17:07','2006-06-15 00:17:07','25'),
 ('177','3','http://www.shifteleven.com/articles/2006/09/28/loading-fixtures-in-a-migration','Fixtures in a Migration','2006-11-01 14:25:27',null,'24'),
 ('178','3','http://api.rubyonrails.com/classes/ActiveRecord/ConnectionAdapters/TableDefinition.html','API - Table Definitions','2006-03-05 23:17:07','2006-07-08 00:17:07','23'),
 ('179','3','http://api.rubyonrails.com/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html','API - Schema Statements','2006-03-09 23:17:07','2006-07-15 00:17:07','22'),
 ('180','3','http://api.rubyonrails.com/classes/ActiveRecord/Migration.html','API - Migration','2006-03-30 23:17:07','2006-06-23 00:17:07','21'),
 ('181','3','http://wiki.rubyonrails.com/rails/pages/UsingMigrations','Wiki - Using Migrations','2006-02-27 23:17:07','2006-07-30 00:17:07','20'),
 ('182','3','http://wiki.rubyonrails.org/rails','RoR - Wiki','2006-03-23 23:17:07','2006-05-04 00:17:07','19'),
 ('183','3','http://weblog.rubyonrails.org/','RoR - Blog','2006-04-26 00:17:07','2006-05-28 00:17:07','18'),
 ('184','3','http://www.recentrambles.com/pragmatic/view/43','Blog Post on RJS','2006-08-09 23:05:00',null,'17'),
 ('185','3','http://api.rubyonrails.com/classes/ActionView/Helpers/ScriptaculousHelper.html','AVH - Scriptaculous Hlpr.','2006-08-09 22:59:05',null,'16'),
 ('186','3','http://api.rubyonrails.com/classes/ActionView/Helpers/PrototypeHelper/JavaScriptGenerator/GeneratorMethods.html','AVH - Prototype Hlpr. JSG','2006-08-09 22:59:08',null,'15'),
 ('187','3','http://api.rubyonrails.com/classes/ActionView/Helpers/PrototypeHelper.html','AVH - Prototype Hlpr.','2006-08-09 22:59:09',null,'14'),
 ('188','3','http://api.rubyonrails.com/classes/ActionView/Helpers/JavaScriptMacrosHelper.html','AVH - JS Macros Hlpr.','2006-08-09 22:59:10',null,'13'),
 ('189','3','http://api.rubyonrails.com/classes/ActionView/Helpers/JavaScriptHelper.html','AVH - JS Hlpr.','2006-08-09 22:59:11',null,'12'),
 ('190','3','http://dev.upian.com/hotlinks/tag/dhtml','DHTML Hotlinks','2006-03-03 23:17:07','2006-07-27 00:17:07','11'),
 ('191','3','http://boygeni.us/tooltips/','Tooltip (misc example)','2006-10-29 11:56:19',null,'10'),
 ('192','3','http://tooltip.crtx.org/','Tooltip.js Project','2006-10-29 11:50:25',null,'9'),
 ('193','3','http://looksgoodworkswell.blogspot.com/2005/11/popups-with-twist.html','Popups With a Twist','2006-02-02 23:17:07','2006-05-21 00:17:07','8'),
 ('194','3','http://particletree.com/features/quick-guide-to-prototype/','Quick Guide to Prototype','2006-08-09 23:16:08',null,'7'),
 ('195','3','http://www.sitepoint.com/article/painless-javascript-prototype','Site Point - Using Prototype','2006-08-09 23:16:04',null,'6'),
 ('196','3','http://www.google.com/','test','2006-11-27 09:53:17',null,'5'),
 ('197','3','','','2006-08-10 09:49:29',null,'4'),
 ('198','3','http://www.google.com/','Google','2006-11-27 10:12:14',null,'3'),
 ('199','3','http://www.google.com/','Google','2006-11-27 20:39:45',null,'2'),
 ('200','3','http://www.oreilly.com/catalog/mongrelpdf/','O\'Reilly.com - Mongrel','2006-11-17 08:32:28',null,'1');

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `salted_password` varchar(40) NOT NULL default '',
  `email` varchar(60) NOT NULL default '',
  `salt` varchar(40) NOT NULL default '',
  `verified` tinyint(1) default '0',
  `security_token` varchar(40) default NULL,
  `token_expiry` datetime default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `logged_in_at` datetime default NULL,
  `deleted` tinyint(1) default '0',
  `delete_after` datetime default NULL,
  `uuid` varchar(32) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `indx_users_uuid` (`uuid`),
  UNIQUE KEY `indx_users_email` (`email`),
  KEY `indx_users_id` (`id`),
  KEY `indx_users_email_salted_password` (`email`,`salted_password`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

insert into `users` values('1','2688bc9b25f28481043566241fff99878b3d93c9','ken@metaskills.net','0db07e668791f9eb747e4560633a095fc40ac57f','1','15cf64e69055c42e7c59155e0728f390a14be9eb','2006-04-18 16:41:17','2006-04-16 11:55:09','2006-11-26 22:10:23','2006-11-26 22:10:23','0',null,'1dafa9703dff01297f850016cbcc36eb'),
 ('6','2688bc9b25f28481043566241fff99878b3d93c9','ken@actionmoniker.com','0db07e668791f9eb747e4560633a095fc40ac57f','1','488cf35f3b6d9f304b7e9f7b751c5c2f4c87e2bd','2006-10-04 15:06:56','2006-09-30 10:56:59','2006-11-26 13:00:42','2006-11-26 13:00:42','0',null,'1dafa9703dff01297f850016cbcc36ec');

SET FOREIGN_KEY_CHECKS = 1;
