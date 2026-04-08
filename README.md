<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apishop - Online Edition</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Kanit:wght@300;400;600&display=swap" rel="stylesheet">
    <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-database-compat.js"></script>
    <style>
        * { font-family: 'Kanit', sans-serif; box-sizing: border-box; }
        body { background-color: #020617; color: #e2e8f0; margin: 0; min-height: 100vh; }
        .glass { background: rgba(15, 23, 42, 0.8); backdrop-filter: blur(12px); border: 1px solid rgba(255,255,255,0.05); }
        .btn-cyan { background: linear-gradient(45deg, #0891b2, #06b6d4); color: white; transition: 0.3s; border: none; cursor: pointer; text-align: center; }
        .btn-cyan:hover { filter: brightness(1.2); transform: translateY(-2px); }
        .hidden { display: none !important; }
        .category-pill { cursor: pointer; transition: 0.2s; border: 1px solid rgba(255,255,255,0.1); }
        .category-pill.active { background-color: #06b6d4; color: white; border-color: #06b6d4; }
    </style>
</head>
<body>

    <nav class="p-4 glass sticky top-0 z-50 flex justify-between items-center border-b border-cyan-900/30">
        <div class="flex items-center gap-3 cursor-pointer" onclick="location.reload()">
            <div class="p-2 bg-cyan-500 rounded-lg text-white font-bold shadow-lg shadow-cyan-500/50">AS</div>
            <h1 class="text-xl font-bold text-white tracking-tighter uppercase">Apishop</h1>
        </div>
        <div id="auth-zone" class="flex gap-2 text-sm">
            <button onclick="openM('login-modal')" class="text-white px-2 hover:text-cyan-400">เข้าสู่ระบบ</button>
            <button onclick="openM('reg-modal')" class="btn-cyan px-5 py-1.5 rounded-full font-semibold shadow-lg">สมัครสมาชิก</button>
        </div>
    </nav>

    <main class="container mx-auto p-4 md:p-6">
        <div id="balance-card" class="hidden mb-8 p-6 glass rounded-3xl flex justify-between items-center border-l-8 border-cyan-500">
            <div>
                <p class="text-slate-400 text-xs uppercase tracking-widest">ยอดเงินคงเหลือ</p>
                <h2 class="text-3xl font-bold text-white"><span id="user-money">0</span> <span class="text-cyan-500 text-sm">฿</span></h2>
            </div>
            <div class="flex gap-2">
                <button onclick="showS('history')" class="bg-slate-800 text-white px-4 py-2 rounded-xl text-xs hover:bg-slate-700">📜 ประวัติซื้อ</button>
                <button onclick="showS('topup')" class="bg-cyan-600 text-white px-6 py-2 rounded-xl text-xs font-bold hover:bg-cyan-500 shadow-lg shadow-cyan-500/20">➕ เติมเงิน</button>
            </div>
        </div>

        <section id="home-section">
            <div class="flex flex-col md:flex-row justify-between items-center mb-6 gap-4">
                <h2 class="text-xl font-bold text-white flex items-center gap-2"><span class="w-1.5 h-6 bg-cyan-500 rounded-full"></span> รายการสินค้า</h2>
                <div id="category-filter" class="flex gap-2 overflow-x-auto pb-2 w-full md:w-auto"></div>
            </div>
            <div id="product-list" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6"></div>
        </section>

        <section id="history-section" class="hidden max-w-2xl mx-auto py-6">
            <h2 class="text-2xl font-bold text-white mb-6">ประวัติของท่าน</h2>
            <div id="order-history-list" class="space-y-3"></div>
            <button onclick="showS('home')" class="mt-6 text-cyan-400 text-sm block text-center w-full">← กลับหน้าหลัก</button>
        </section>

        <section id="topup-section" class="hidden max-w-xl mx-auto py-10">
            <div class="glass p-8 rounded-3xl text-center border border-pink-500/30">
                <h2 class="text-2xl font-bold mb-4 text-white uppercase">TrueMoney Wallet</h2>
                <input type="text" id="gift-link" placeholder="วางลิงก์ซองของขวัญที่นี่..." class="w-full p-4 rounded-2xl bg-slate-900 border border-slate-700 mb-4 text-center text-white outline-none focus:border-pink-500">
                <button id="btn-topup-submit" onclick="autoCheckGift()" class="w-full py-4 rounded-2xl bg-gradient-to-r from-pink-600 to-orange-500 font-bold text-white shadow-lg shadow-pink-500/20">ยืนยันเติมเงิน</button>
                <button onclick="showS('home')" class="mt-4 text-slate-500 text-sm block w-full hover:underline font-bold">ยกเลิก</button>
            </div>
        </section>
    </main>

    <div id="admin-panel" class="hidden fixed inset-0 bg-[#020617] z-[100] overflow-y-auto p-4 md:p-8">
        <div class="max-w-7xl mx-auto text-white">
            <div class="flex justify-between items-center mb-8 border-b border-white/10 pb-6">
                <h1 class="text-2xl font-bold text-red-500 italic uppercase">Admin Console</h1>
                <button onclick="closeM('admin-panel')" class="bg-slate-800 px-6 py-2 rounded-xl text-white">ปิดระบบแอดมิน</button>
            </div>
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <div class="glass p-6 rounded-2xl">
                    <h3 class="text-cyan-400 font-bold mb-4">📦 ลงสินค้าใหม่</h3>
                    <input type="text" id="adm-p-name" placeholder="ชื่อสินค้า" class="w-full p-3 mb-2 rounded-xl bg-slate-900 border border-slate-700">
                    <input type="number" id="adm-p-price" placeholder="ราคา" class="w-full p-3 mb-2 rounded-xl bg-slate-900 border border-slate-700">
                    <input type="text" id="adm-p-cat" placeholder="หมวดหมู่" class="w-full p-3 mb-2 rounded-xl bg-slate-900 border border-slate-700">
                    <input type="text" id="adm-p-img" placeholder="URL รูปสินค้า" class="w-full p-3 mb-2 rounded-xl bg-slate-900 border border-slate-700">
                    <textarea id="adm-p-stock" placeholder="ไอดี:รหัส (1 บรรทัด ต่อ 1 อัน)" class="w-full p-3 mb-2 rounded-xl bg-slate-900 border border-slate-700 h-24"></textarea>
                    <button onclick="adminAdd()" class="w-full bg-cyan-600 py-3 rounded-xl font-bold">ลงขายสินค้า</button>
                </div>
                <div class="glass p-6 rounded-2xl"><h3 class="text-green-400 font-bold mb-4">🔄 เติมสต็อก</h3><div id="admin-inventory-list" class="space-y-2"></div></div>
                <div class="glass p-6 rounded-2xl"><h3 class="text-yellow-400 font-bold mb-4">👤 สมาชิก</h3><div id="admin-user-list" class="space-y-2"></div></div>
            </div>
        </div>
    </div>

    <div id="login-modal" class="hidden fixed inset-0 bg-black/90 flex items-center justify-center z-[200] p-4">
        <div class="glass p-8 rounded-3xl w-full max-w-sm border-t-4 border-cyan-500 shadow-2xl">
            <h3 class="text-xl font-bold mb-6 text-center text-white uppercase">Login</h3>
            <input type="text" id="l-user" placeholder="Username" class="w-full p-3 mb-3 rounded-xl bg-slate-900 border border-slate-700 text-white">
            <input type="password" id="l-pass" placeholder="Password" class="w-full p-3 mb-6 rounded-xl bg-slate-900 border border-slate-700 text-white">
            <button onclick="login()" class="w-full btn-cyan py-3 rounded-xl font-bold text-lg shadow-lg">เข้าสู่ระบบ</button>
            <button onclick="closeM('login-modal')" class="w-full mt-4 text-slate-500 text-xs">ปิด</button>
        </div>
    </div>

    <div id="reg-modal" class="hidden fixed inset-0 bg-black/90 flex items-center justify-center z-[200] p-4">
        <div class="glass p-8 rounded-3xl w-full max-w-sm border-t-4 border-cyan-500">
            <h3 class="text-xl font-bold mb-6 text-center text-white uppercase">Register</h3>
            <input type="text" id="r-user" placeholder="Username" class="w-full p-3 mb-3 rounded-xl bg-slate-900 border border-slate-700 text-white">
            <input type="password" id="r-pass1" placeholder="Password" class="w-full p-3 mb-3 rounded-xl bg-slate-900 border border-slate-700 text-white">
            <input type="password" id="r-pass2" placeholder="Confirm Password" class="w-full p-3 mb-6 rounded-xl bg-slate-900 border border-slate-700 text-white">
            <button onclick="register()" class="w-full btn-cyan py-3 rounded-xl font-bold text-lg shadow-lg">สมัครสมาชิก</button>
            <button onclick="closeM('reg-modal')" class="w-full mt-4 text-slate-500 text-xs">ปิด</button>
        </div>
    </div>

    <div id="success-modal" class="hidden fixed inset-0 bg-black/95 flex items-center justify-center z-[400] p-4">
        <div class="glass p-8 rounded-3xl w-full max-w-sm text-center border-t-4 border-green-500">
            <h3 class="text-xl font-bold mb-2 text-white">ซื้อสินค้าสำเร็จ! ✅</h3>
            <input type="text" id="acc-out" readonly class="w-full bg-slate-900 p-4 rounded-xl text-cyan-400 font-bold text-center my-4">
            <button onclick="copyAcc()" class="w-full bg-cyan-600 py-3 rounded-xl text-white font-bold mb-4">คัดลอกรหัส</button>
            <button onclick="closeM('success-modal')" class="text-slate-500 text-xs">ปิด</button>
        </div>
    </div>

    <script>
        // --- Firebase Config ของน้อง ---
        const firebaseConfig = {
          apiKey: "AIzaSyD9c6XQkaxfimS6z3iIg5dh2filSsZ9fR8",
          authDomain: "apishop-c68d5.firebaseapp.com",
          projectId: "apishop-c68d5",
          storageBucket: "apishop-c68d5.firebasestorage.app",
          messagingSenderId: "1036199268260",
          appId: "1:1036199268260:web:ca385d7ccc7e321296fb31",
          databaseURL: "https://apishop-c68d5-default-rtdb.asia-southeast1.firebasedatabase.app"
        };

        firebase.initializeApp(firebaseConfig);
        const db = firebase.database();

        let users = [];
        let products = [];
        let currentUser = null;
        let activeCat = 'all';

        // ดึงข้อมูล User
        db.ref('users').on('value', (s) => { 
            const val = s.val();
            users = val ? Object.values(val) : []; 
            if(currentUser) {
                const updated = users.find(u => u.username === currentUser.username);
                if(updated) { currentUser = updated; updateUI(); }
            }
            renderAdmin();
        });

        // ดึงข้อมูลสินค้า
        db.ref('products').on('value', (s) => { 
            const val = s.val();
            products = val ? Object.keys(val).map(key => ({...val[key], id: key})) : []; 
            renderP(); 
            renderAdmin(); 
        });

        // ระบบ UI
        function openM(id) { document.getElementById(id).classList.remove('hidden'); }
        function closeM(id) { document.getElementById(id).classList.add('hidden'); }
        function showS(id) {
            ['home', 'topup', 'history'].forEach(s => document.getElementById(s + '-section').classList.add('hidden'));
            document.getElementById(id + '-section').classList.remove('hidden');
            if(id === 'history') renderHistory();
        }

        // ระบบสมัครสมาชิก
        function register() {
            const u = document.getElementById('r-user').value.trim();
            const p1 = document.getElementById('r-pass1').value;
            const p2 = document.getElementById('r-pass2').value;
            if(!u || !p1 || p1 !== p2) return alert('ข้อมูลไม่ถูกต้อง');
            if(users.find(x => x.username === u)) return alert('ชื่อนี้มีคนใช้แล้ว');
            
            db.ref('users/' + u).set({ username: u, password: p1, balance: 0, orders: [] })
            .then(() => { alert('สมัครสำเร็จ!'); closeM('reg-modal'); });
        }

        // ระบบล็อกอิน
        function login() {
            const u = document.getElementById('l-user').value.trim();
            const p = document.getElementById('l-pass').value;
            
            // แอดมินรหัสลับ
            if(u === 'Apishop' && p === 'Apishop100955') {
                const k = prompt("Master Key:");
                if(k === "100955") { openM('admin-panel'); closeM('login-modal'); return; }
            }

            const user = users.find(x => x.username === u && x.password === p);
            if(user) { currentUser = user; updateUI(); closeM('login-modal'); }
            else alert('รหัสผิด!');
        }

        function updateUI() {
            if(!currentUser) return;
            document.getElementById('balance-card').classList.remove('hidden');
            document.getElementById('user-money').innerText = currentUser.balance;
            document.getElementById('auth-zone').innerHTML = `<span class="text-cyan-400 font-bold">${currentUser.username}</span><button onclick="location.reload()" class="text-red-500 ml-2">ออก</button>`;
        }

        // ระบบซื้อสินค้า
        function buyProduct(pId) {
            if(!currentUser) return alert('ล็อกอินก่อน!');
            const p = products.find(x => x.id == pId);
            if(!p || !p.stock || p.stock.length === 0) return alert('หมด!');
            if(currentUser.balance < p.price) return alert('เงินไม่พอ!');

            const acc = p.stock.shift();
            const newBalance = currentUser.balance - p.price;
            const order = { name: p.name, account: acc, date: new Date().toLocaleString() };
            if(!currentUser.orders) currentUser.orders = [];
            currentUser.orders.unshift(order);

            const updates = {};
            updates['/products/' + pId + '/stock'] = p.stock;
            updates['/users/' + currentUser.username + '/balance'] = newBalance;
            updates['/users/' + currentUser.username + '/orders'] = currentUser.orders;

            db.ref().update(updates).then(() => {
                document.getElementById('acc-out').value = acc;
                openM('success-modal');
            });
        }

        // ระบบแอดมิน
        function adminAdd() {
            const n = document.getElementById('adm-p-name').value;
            const p = parseInt(document.getElementById('adm-p-price').value);
            const s = document.getElementById('adm-p-stock').value.split('\n').filter(l => l.trim() !== "");
            if(!n || !p) return alert('กรอกไม่ครบ!');
            const id = Date.now();
            db.ref('products/' + id).set({ name: n, price: p, cat: document.getElementById('adm-p-cat').value || 'ทั่วไป', img: document.getElementById('adm-p-img').value || '', stock: s });
            alert('ลงแล้ว!');
        }

        // เรนเดอร์สินค้า
        function renderP() {
            const list = document.getElementById('product-list');
            list.innerHTML = products.map(p => `
                <div class="glass p-5 rounded-3xl border border-slate-800 flex flex-col justify-between">
                    <img src="${p.img || 'https://via.placeholder.com/150'}" class="w-full h-32 object-cover rounded-2xl mb-4 bg-slate-900">
                    <h3 class="text-white font-bold">${p.name}</h3>
                    <p class="text-xs text-slate-500 mb-4">คงเหลือ: ${p.stock ? p.stock.length : 0}</p>
                    <div class="flex justify-between items-center">
                        <span class="text-xl font-bold text-white">${p.price} ฿</span>
                        <button onclick="buyProduct('${p.id}')" class="bg-cyan-600 px-4 py-2 rounded-xl text-xs font-bold">ซื้อ</button>
                    </div>
                </div>`).join('');
        }

        // ประวัติ
        function renderHistory() {
            const list = document.getElementById('order-history-list');
            if(!currentUser.orders) return list.innerHTML = '<p class="text-center text-slate-500">ไม่มีประวัติ</p>';
            list.innerHTML = currentUser.orders.map(o => `<div class="glass p-4 rounded-2xl border border-white/5"><p class="text-[10px] text-slate-500">${o.date}</p><h4 class="font-bold text-white">${o.name}</h4><p class="text-cyan-400 font-mono text-xs">ID: ${o.account}</p></div>`).join('');
        }

        function adminAdd() {
            const n = document.getElementById('adm-p-name').value;
            const p = parseInt(document.getElementById('adm-p-price').value);
            const c = document.getElementById('adm-p-cat').value || 'ทั่วไป';
            const img = document.getElementById('adm-p-img').value || 'https://via.placeholder.com/150';
            const s = document.getElementById('adm-p-stock').value.split('\n').filter(l => l.trim() !== "");
            if(!n || !p) return alert('กรอกข้อมูลไม่ครบ!');
            const id = Date.now();
            db.ref('products/' + id).set({ name: n, price: p, cat: c, img: img, stock: s })
            .then(() => { alert('ลงแล้ว!'); });
        }

        function renderAdmin() {
            document.getElementById('admin-inventory-list').innerHTML = products.map(p => `<div class="p-2 bg-slate-900 rounded-xl flex justify-between text-xs"><span>${p.name}</span><button onclick="db.ref('products/${p.id}').remove()" class="text-red-500">ลบ</button></div>`).join('');
            document.getElementById('admin-user-list').innerHTML = users.map(u => `<div class="p-2 bg-slate-900 rounded-xl flex justify-between text-xs"><span>${u.username}</span><span class="text-cyan-400">${u.balance} ฿</span></div>`).join('');
        }

        function autoCheckGift() {
            if(!currentUser) return;
            const amt = Math.floor(Math.random() * 50) + 10;
            db.ref('users/' + currentUser.username + '/balance').set(currentUser.balance + amt)
            .then(() => { alert('เติมสำเร็จ (Demo): ' + amt + ' บาท'); showS('home'); });
        }

        function copyAcc() { const out = document.getElementById('acc-out'); out.select(); document.execCommand('copy'); alert('คัดลอกแล้ว!'); }
    </script>
</body>
</html>
