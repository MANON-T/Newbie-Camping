# Dev Site
ฝั่งสำหรับนักพัฒนาที่ต้องการจะอัปเดท ปรับปุง หรือแก้ไขโค้ด

> ตั้งค่า Firebase

Android package name ของโปรเจคนี้คือ    `com.example.flutter_application_4`

โปรเจ็คนี้ได้ตั้งค่าให้เข้ากับ Firebase เป็นที่เรียบร้อยแล้ว คุณสามารถนำไฟล์ `google-services.json(ของคุณ)` ที่ได้มาจากการเพิ่มแอปพลิเคชันบน Firebase มาใส่ในโปรเจคได้เลยโดยไม่ต้องปรับปรุงโค้ดส่วนอื่น

> โครงสร้างฐานข้อมูล Firebase

![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/Forestore%20Database%20bar/Data.png)

ในโปรเจคนี้เราใช้ตัว `Forestore Database` ซึ่งเป็นฐานข้อมูลชนิด `Document Store` ซึ่งมีความต่างจาก `SQL` ดังนั้นจึงขอแนะนำให้ทำความรู้จักกับฐานข้อมูลชนิดนี้เสียก่อนเพื่อให้สามารถใช้งานได้อย่างลื่นไหล
สำหรับตัวฐานข้อมูลจะมีทั้งหมด 3 Collection ได้แก่

 - campsite : Collection สำหรับเก็บข้อมูลของสถานที่ตั้งแคมป์
 - tip : Collection สำหรับเก็บเกล็ดความรู้และบทความต่างๆ
 - user : Collection สำหรับเก็บข้อมูลของสผู้ใช้

โดยแต่ละ Collection จะมี Document ID เป็นค่า Auto-ID ที่ทาง Firebase สุ่มมาให้ โดยที่แต่ละ Document ของแต่ละ Collection จะมี Field ดังต่อไปนี้

 1. campsite
 
|ชื่อ|ชนิดข้อมูล|คำอธิบาย|ตัวอย่าง|
|--|--|--|--|
|House|array|ราคาบ้านพัก : โดยจะแบ่งเป็นราคาของบั้นพักขนาดเล็ก(2-3คน),กลาง(4-6คน),ใหญ่(8-10คน) โดยหากสถานที่นั้นไม่มีบ้านพักขนาดเล็ก,กลาง หรือขนาดใหญ่ ให้ใส่ค่าเป็น 0 โดยค่าของข้อมูลใน Array จะเป็นชนิด number|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/House.png)|
|Tent_rental|array|ราคาเต้นเช่า : มีลักษณะเหมือนกับ field House โดยจะแบ่งเป็นเต้นเช่าขนาดเล็ก(2คน),กลาง(4คน),ใหญ่(6คน) โดยหากสถานที่นั้นไม่มีเต้นเช่าขนาดเล็ก,กลาง หรือขนาดใหญ่ ให้ใส่ค่าเป็น 0 โดยค่าของข้อมูลใน Array จะเป็นชนิด number|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/Tent_rental.png)|
|accommodation_available|boolean|มีบ้านพัก : true , ไม่มีบ้านพัก : false|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/accommodation_available.png)|
|activities|array|กิจกรรม : เก็บข้อมูลเกี่ยวกับกิจกรรมภายในสถานที่นั้นๆ โดยข้อมูลใน Array จะเป็น String|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/activities.png)|
|adult_entry_fee|number|ค่าเข้าผู้ใหญ่ : หากสถานที่นั้นไม่เก็บค่าเข้าของผู้ใหญ่ให้ใส่ค่าเป็น 0|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/adult_entry_fee.png)|
|camp_score|number|คะแนนแคมป์ : การนำ factor หรือปัจจัยที่เกี่ยวข้องมาจัดเป็นคะแนนโดยวิธีการคำนวนจะอยู่ที่เนื้อหาด้านล่าง|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/camp_score.png)|
|campimage|array|รูปภาพแคมป์ : โดยการเก็บรูปภาพจะถูกเก็บไว้ในโฟลเดอร์ images ดังนั้นการบันทึกจะเป็นการบันทึกรูปแบบ String ของ path ที่เก็บรูปภาพไว้ โดยในที่นี้ก็จะเป็น images/Document ID ของสถานที่นั้น_จำนวนตั้งแต่ 2 ขึ้นไป.png,jpg,jpeg ตามที่ได้บันทึกไว้|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/campimage.png)|
|camping_fee|number|ค่ากางเต้น : หากสถานที่นั้นไม่เก็บค่ากางเต้นให้ใส่ค่าเป็น 0|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/camping_fee.png)|
|child_entry_fee|number|ค่าเข้าเด็ก : หากสถานที่นั้นไม่เก็บค่าเข้าของเด็กให้ใส่ค่าเป็น 0|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/child_entry_fee.png)|
|clean_restrooms|boolean|ห้องน้ำสะอาด : true , ห้องน้ำไม่สะอาด : false|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/clean_restrooms.png)|
|common_backpack1|array|กระเป๋าสำหรับคนทั่วไป1 : เก็บข้อมูลของที่ควรเตรียมสำหรับไปยังสถานที่นั้นๆ โดยเก็บข้อมูลเป็น String โดยจะมีข้อมูลกี่รายการก็ได้|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/common_backpack1.png)|
|common_backpack2|array|กระเป๋าสำหรับคนทั่วไป2 : เก็บข้อมูลเหมือน กระเป๋าสำหรับคนทั่วไป1 แต่รายการของที่ควรเตรียมจะแตกต่างออกไป|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/common_backpack2.png)|
|gender_separated_restrooms|boolean|ห้องน้ำแยกชายหญิง : true , ห้องน้ำไม่แยกชายหญิง : false|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/gender_separated_restrooms.png)|
|imageURL|string|รูปภาพปก : เก็บข้อมูลเหมือน campimage แต่มีแค่รายการเดียวและตัวเลขข้างหลังจะเป็นเลข 1 |![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/imageURL.png)|
|location_coordinates|geopoint|พิกัด : เก็บข้อมูลละติจูดและลองติจูดของสถานที่|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/location_coordinates.png)|
|name|string|ชื่อสถานที่ตั้งแคมป์|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/name.png)|
|newbie_backpack|array|กระเป๋าสำหรับมือใหม่ : เก็บข้อมูลเหมือน common_backpack1,2 แต่จะเป็นข้อมูลที่ละเอียดและเข้าใจง่ายกว่า เพื่อให้เหมาะสำหรับมือใหม่|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/newbie_backpack.png)|
|parking_fee|number|ค่าจอดรถ : หากสถานที่นั้นไม่เก็บค่าจอดรถให้ใส่ค่าเป็น 0|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/parking_fee.png)|
|phone_signal|array|สัญญาณโทรศัพท์ : เก็บข้อมูลของสัญญาณมือถือโดยแบ่งจากสี 🟢 สัญญาณแรง , 🟠 สัญญาณปานกลาง , 🔴 สัญญาณแย่|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/phone_signal.png)|
|power_access|boolean|มีไฟฟ้าต่อพ่วง : true , ไม่มีไฟฟ้าต่อพ่วง : false|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/power_access.png)|
|tag|array|แท็ก : สำหรับเก็บข้อมูลที่เกี่ยวข้องเพื่อนำข้อมูลมาคัดกรอง|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/tag.png)|
|tent_service|boolean|มีเต้นให้เช่า : true , ไม่มีเต้นให้เช่า : false|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/tent_service.png)|
|warning|array|คำเตือน : เก็บข้อมูลคำเตือนของแต่ละสถานที่เป็น String|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/campsite/warning.png)|

 2. tip

|ชื่อ|ชนิดข้อมูล|คำอธิบาย|ตัวอย่าง|
|--|--|--|--|
|description|string|รายละเอียด : เก็บเนื้อหาของบทความไม่จำกัดความยาว|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/tip/description.png)|
|imageURL|string|รูปภาพปก : เก็บข้อมูลเหมือน imageURL ใน collection campsite แต่จะไม่มีตัวเลข_...ต่อข้างหลัง|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/tip/imageURL.png)|
|timestamp|timestamp|ไทม์แสตม : เก็บข้อมูลเวลาที่สร้างบทความเพื่อนำมาเรียงลำดับในการแสดงผล|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/tip/timestamp.png)|
|topic|string|หัวข้อ|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/tip/topic.png)|

 3. user
 
|ชื่อ|ชนิดข้อมูล|คำอธิบาย|ตัวอย่าง|
|--|--|--|--|
|backpack|string|กระเป๋าสัมภาระ : ประเภทกระเป๋าที่ผู้ใช้ได้เลือก|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/user/backpack.png)|
|campingFee|number|ค่ากางเต้นของสถานที่ๆผู้ใช้ได้เลือกไว้|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/user/campingFee.png)|
|campsite|string|ชื่อสถานที่ๆผู้ใช้ได้เลือกไว้|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/user/campsite.png)|
|email|string|อีเมลของผู้ใช้ที่ใช้ทำการเข้าสู่ระบบทั้งนี้หากผู้ใช้เข้าสู่ระบบโดยไม่ระบุตัวตนข้อมูลนี้จะเก็บเป็น String คำว่า "ไม่ระบุตัวตน"|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/user/email.png)|
|enterFee|number|ค่าเข้าของสถานที่ๆผู้ใช้ได้เลือกไว้|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/user/enterFee.png)|
|exp|string|ประสบการณ์ของผู้ใช้โดยจะได้จากการเลือกประสบการณ์ก่อนถึงหน้าเข้าสู่ระบบ|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/user/exp.png)|
|house|number|ค่าเช่าบ้านพักของสถานที่ๆผู้ใช้ได้เลือกไว้|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/user/house.png)|
|id|string|ไอดีของผู้ใช้|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/user/id.png)|
|name|string|ชื่อของผู้ใช้|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/user/name.png)|
|tentRental|number|ค่าเช่าเต้นของสถานที่ๆผู้ใช้ได้เลือกไว้|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/user/tentRental.png)|
|totalCost|number|ค่ารวมของสถานที่ๆผู้ใช้ได้เลือกไว้|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/user/totalCost.png)|
|tag|array|แท็กของผู้ใช้ : เมื่อเริ่มต้นฟิลด์นี้จะเป็น array ที่มีค่าว่าง โดยจะถูกเพิ่มค่าจากการกดเลือกแท็กผ่านตัวแอป ข้อมูลว่ามีเท็กอะไรบ้างจะแยู่ในหัวข้อถัดๆไป|![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/user/tag.png)|
> Rules

![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/Forestore%20Database%20bar/Rules.png)

ในการดึงข้อมูลหรือเขียนข้อมูลลงใน Firebase จำเป็นต้องกำหนดกฏหรือ rules เพื่อเป็นการกำหนดสิทธิในการเข้าถึงของผู้ใช้ โดยโค้ดต่อไปนี้เป็นกฏที่ใช้สำหรับ Firebase นี้สามารถนำไปวางแทนกฏเก่าได้เลย

    rules_version = '2';

	service cloud.firestore {
		match /databases/{database}/documents {
		// กฎสำหรับคอลเลกชัน user
	    match /user/{userId} {
	      allow read, write: if request.auth != null;
	    }
    
	    // กฎสำหรับคอลเลกชัน campsite
	    match /campsite/{campsiteId} {
	      allow read: if request.auth != null; // อนุญาตการอ่านสำหรับผู้ใช้ที่ตรวจสอบสิทธิ์แล้ว
	      allow write: if request.auth != null && request.auth.uid == 'adminUid'; // อนุญาตการเขียนเฉพาะ admin
	      allow update: if request.auth != null && request.auth.uid == 'adminUid'; // อนุญาตการอัปเดตเฉพาะ admin
	    }
    
	    // กฎสำหรับคอลเลกชัน tip
	    match /tip/{tipId} {
	      allow read: if request.auth != null;
	      allow write: if request.auth != null && request.auth.uid == 'adminUid';
	    }
	  }
	}

> Indexes

![enter image description here](https://github.com/MANON-T/Newbie-Camping/blob/main/Tutorial%20Material/Forestore%20Database%20bar/Indexes.png)

การกำหนด Index ในส่วนนี้ใช้สำหรับการค้นหาโดยสามารถทำได้โดยการเลือกตามหัวข้อต่อไปนี้
|Collection ID| Fields indexed |||Query scope|
|--|--|--|--|--|
|`campsite`| `name : Ascending` |`score : Descending`|`__name__ Descending`|`Collection`|

> วิธีคิดคะแนน camp score

เพื่อทำการวิเคราะห์ปัจจัยต่างๆที่ส่งผลต่อการเลือกสถานที่ตั้งแคมป์แต่ละแห่ง เราสามารถพิจารณาความสำคัญของแต่ละปัจจัยตามประสบการณ์และความต้องการของผู้ตั้งแคมป์ทั่วไป โดยกำหนดคะแนนเต็ม 100 คะแนน โดยการแจกแจงคะแนนในแต่ละปัจจัยดังนี้:

1. ค่าเข้าผู้ใหญ่ (Entry fee for adults) - 10 คะแนน
2. ค่าเข้าเด็ก (Entry fee for children) - 5 คะแนน
3. ค่าจอดรถ (Parking fee) - 5 คะแนน
4. ค่ากางเต้น (Tent pitching fee) - 5 คะแนน
5. มีบ้านพัก (Availability of cabins) - 10 คะแนน
6. มีเต้นบริการ (Availability of rental tents) - 5 คะแนน
7. มีกิจกรรม (Availability of activities) - 10 คะแนน
8. ห้องน้ำสะอาด (Cleanliness of restrooms) - 15 คะแนน
9. ห้องน้ำแยกชายหญิง (Separate restrooms for men and women) - 5 คะแนน
10. สัญญาณโทรศัพท์ (Mobile phone signal) - 5 คะแนน
11. ไฟฟ้าต่อพ่วง (Electricity hook-ups) - 5 คะแนน
12. ราคาบ้านพัก (Cabin price) - 10 คะแนน
13. ราคาเต้น (Tent price) - 10 คะแนน

คะแนนรวมทั้งหมด: 100 คะแนน

ปัจจัยที่สำคัญที่สุดคือความสะอาดของห้องน้ำซึ่งมีผลต่อความสะดวกสบายและสุขอนามัย โดยให้คะแนนสูงถึง 15 คะแนน ส่วนปัจจัยอื่นๆที่สำคัญเช่น ค่าเข้าผู้ใหญ่, มีบ้านพัก, มีกิจกรรม, ราคาบ้านพัก, และราคาเต้น ได้รับคะแนน 10 คะแนนแต่ละปัจจัย เนื่องจากส่งผลต่อการเลือกสถานที่ตั้งแคมป์เป็นอย่างมาก ส่วนปัจจัยอื่นๆที่มีความสำคัญรองลงมาได้รับคะแนนตามความสำคัญลดหลั่นลงมา

> แท็กทั้งหมดที่ผู้ใช้สามารถเลือกได้

1. **#CampLover** - สำหรับผู้ที่หลงใหลในการตั้งแคมป์เป็นชีวิตจิตใจ
2. **#NatureExplorer** - สำหรับผู้ที่ชอบสำรวจธรรมชาติและสถานที่ใหม่ๆ
3. **#WildCook** - สำหรับผู้ที่ชอบทำอาหารกลางแจ้ง
4. **#MountainClimber** - สำหรับผู้ที่ชอบปีนเขาและตั้งแคมป์บนภูเขา
5. **#BeachCamper** - สำหรับผู้ที่ชอบตั้งแคมป์ที่ชายหาด
6. **#SoloCamper** - สำหรับผู้ที่ชอบการตั้งแคมป์คนเดียว
7. **#FamilyCamper** - สำหรับผู้ที่ชอบตั้งแคมป์กับครอบครัว
8. **#EcoFriendlyCamper** - สำหรับผู้ที่ใส่ใจเรื่องสิ่งแวดล้อมและการตั้งแคมป์แบบรักษ์โลก

> Firebase  Authentication

เป็นส่วนของตัวเลือกการเข้าสู่ระบบของทาง Firebase โดยโปรเจคนี้ยังมี Authentication แค่ 2 แบบคือ Email/Password และ Anonymous
 
> ตั้งค่า GOOGLE MAP API KEY

สำหรับ API ที่ใช้จะมี 2 ตัวคือ Directions API และ Maps SDK for Android เมื่อเลือก API และได้ API Key มาแล้วสามารถนำไปแทนที่โค้ดในส่วนของไฟล์ข้างล่างได้เลย

android\app\src\main\AndroidManifest.xml
บรรทัดที่ 35 : `android:value="YOUR API KEY"/>`

lib/service/api.dart
บรรทัดที่ 1 : `const String GOOGLE_API_KEY = "YOUR API KEY";`


