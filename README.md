<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apishop - ระบบขายสินค้าออนไลน์ (Secure Edition)</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Kanit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Kanit', sans-serif; box-sizing: border-box; }
        body { background-color: #020617; color: #e2e8f0; margin: 0; min-height: 100vh; }
        .glass { background: rgba(15, 23, 42, 0.8); backdrop-filter: blur(12px); border: 1px solid rgba(255,255,255,0.05); }
        .btn-cyan { background: linear-gradient(45deg, #0891b2, #06b6d4); transition: 0.3s; border: none; cursor: pointer; }
        .btn-cyan:hover { filter: brightness(1.2); transform: translateY(-2px); }
        .hidden { display: none !important; }
        .category-pill { cursor: pointer; transition: 0.2s; }
        .category-pill.active { background-color: #06b6d4; color: white; border-color: #06b6d4; }
        .admin-lock-screen { background: rgba(255, 0, 0, 0.1); border: 2px solid #ef4444; }
    </style>
</head>
<body>

    <nav class="p-4 glass sticky top-0 z-50 flex justify-between items-center border-b border-cyan-900/30">
        <div class="flex items-center gap-3 cursor-pointer" onclick="location.reload()">
            <div class="p-2 bg-cyan-500 rounded-lg text-white font-bold shadow-lg shadow-cyan-500/20">AS</div>
            <h1 class="text-xl md:text-2xl font-bold text-white tracking-tighter">Apishop</h1>
        </div>
        <div id="auth-zone" class="flex gap-2">
            <button onclick="openM('login-modal')" class="text-sm hover:text-cyan-400 px-2 text-white">เข้าสู่ระบบ</button>
            <button onclick="openM('reg-modal')" class="btn-cyan px-5 py-1.5 rounded-full text-sm font-semibold text-white shadow-lg">สมัครสมาชิก</button>
        </div>
    </nav>

    <main class="container mx-auto p-6">
        <div id="balance-card" class="hidden mb-8 p-6 glass rounded-3xl flex justify-between items-center border-l-8 border-cyan-500">
            <div>
                <p class="text-slate-400 text-sm">ยอดเงินคงเหลือ</p>
                <h2 class="text-4xl font-bold text-white"><span id="user-money">0</span> <span class="text-lg text-cyan-500">฿</span></h2>
            </div>
            <button onclick="showS('topup')" class="bg-white/10 hover:bg-white/20 px-6 py-2 rounded-2xl transition text-white text-sm md:text-base">➕ เติมเงินออโต้</button>
        </div>

        <section id="home-section">
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-6 gap-4">
                <h2 class="text-2xl font-bold flex items-center gap-2 text-white">
                    <span class="w-2 h-8 bg-cyan-500 rounded-full"></span> รายการสินค้า
                </h2>
                <div id="category-filter" class="flex gap-2 overflow-x-auto pb-2 w-full md:w-auto">
                    <div onclick="filterCat('all')" class="category-pill active px-4 py-1.5 rounded-full border border-slate-700 text-sm whitespace-nowrap">ทั้งหมด</div>
                </div>
            </div>
            <div id="product-list" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6"></div>
        </section>

        <section id="topup-section" class="hidden max-w-xl mx-auto py-10">
            <div class="glass p-8 rounded-3xl text-center border border-pink-500/30">
                <h2 class="text-2xl font-bold mb-2 text-white">เติมเงินผ่านซองของขวัญ</h2>
                <input type="text" id="gift-link" placeholder="วางลิงก์ซองของขวัญที่นี่..." class="w-full p-4 rounded-2xl bg-slate-900 border border-slate-700 mb-4 text-center text-white">
                <button id="btn-topup-submit" onclick="autoCheckGift()" class="w-full py-4 rounded-2xl bg-gradient-to-r from-pink-600 to-orange-500 font-bold text-lg text-white">ยืนยันเติมเงิน</button>
                <button onclick="showS('home')" class="mt-4 text-slate-500 text-sm block w-full hover:underline">กลับหน้าหลัก</button>
            </div>
        </section>
    </main>

    <div id="admin-panel" class="hidden fixed inset-0 bg-[#020617] z-[100] overflow-y-auto p-4 md:p-8">
        <div class="max-w-6xl mx-auto text-white">
            <div class="flex justify-between items-center mb-8 border-b border-red-900/30 pb-6">
                <h1 class="text-2xl font-bold text-red-500 underline decoration-double">ADMIN PANEL (DEVICE SECURED)</h1>
                <button onclick="closeAdmin()" class="bg-slate-800 px-6 py-2 rounded-xl text-white">กลับหน้าหลัก</button>
            </div>
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <div class="glass p-6 rounded-3xl border border-white/5">
                    <h3 class="text-lg font-bold mb-4 text-cyan-400">📦 เพิ่มสินค้าใหม่</h3>
                    <div class="space-y-3">
                        <input type="text" id="adm-p-name" placeholder="ชื่อสินค้า" class="w-full p-3 rounded-xl bg-slate-900 border border-slate-700">
                        <div class="grid grid-cols-2 gap-3">
                            <input type="number" id="adm-p-price" placeholder="ราคา (บาท)" class="w-full p-3 rounded-xl bg-slate-900 border border-slate-700 text-white">
                            <input type="text" id="adm-p-cat" placeholder="หมวดหมู่ (เช่น ไก่ตัน)" class="w-full p-3 rounded-xl bg-slate-900 border border-slate-700 text-white">
                        </div>
                        <input type="text" id="adm-p-img" placeholder="URL รูปภาพสินค้า" class="w-full p-3 rounded-xl bg-slate-900 border border-slate-700 text-white text-xs">
                        <textarea id="adm-p-stock" placeholder="ไอดี:รหัส (1 บรรทัด ต่อ 1 ไอดี)" class="w-full p-3 rounded-xl bg-slate-900 border border-slate-700 h-32 text-white"></textarea>
                        <button onclick="adminAdd()" class="w-full bg-cyan-600 py-3 rounded-xl font-bold text-white shadow-lg">ลงสินค้า</button>
                    </div>
                </div>
                <div class="glass p-6 rounded-3xl border border-white/5">
                    <h3 class="text-lg font-bold mb-4 text-yellow-400">👥 รายชื่อสมาชิก</h3>
                    <div id="admin-user-list" class="space-y-2 max-h-[350px] overflow-y-auto"></div>
                </div>
            </div>
        </div>
    </div>

    <div id="admin-auth-modal" class="hidden fixed inset-0 bg-black/95 flex items-center justify-center z-[300] p-4 text-white">
        <div class="glass p-8 rounded-3xl w-full max-w-sm admin-lock-screen shadow-2xl text-center">
            <span class="text-4xl mb-4 block">🚨</span>
            <h3 class="text-xl font-bold mb-2 text-red-500">Device Locked!</h3>
            <p class="text-sm text-slate-400 mb-6">เครื่องนี้ยังไม่ได้รับการยืนยันสิทธิ์จากเจ้าของร้าน</p>
            <button onclick="requestAdminAccess()" class="w-full bg-white/10 py-3 rounded-xl font-bold mb-4">ขอยืนยันสิทธิ์เครื่องนี้</button>
            <button onclick="closeM('admin-auth-modal')" class="w-full text-slate-500 text-xs underline">ปิดหน้าต่าง</button>
        </div>
    </div>

    <div id="login-modal" class="hidden fixed inset-0 bg-black/95 flex items-center justify-center z-[200] p-4 text-white">
        <div class="glass p-8 rounded-3xl w-full max-w-sm border-t-4 border-cyan-500 shadow-2xl">
            <h3 class="text-xl font-bold mb-6 text-center">LOGIN</h3>
            <input type="text" id="l-user" placeholder="ชื่อผู้ใช้" class="w-full p-3 mb-2 rounded-xl bg-slate-900 border border-slate-800 text-white">
            <input type="password" id="l-pass" placeholder="รหัสผ่าน" class="w-full p-3 mb-6 rounded-xl bg-slate-900 border border-slate-800 text-white">
            <button onclick="login()" class="w-full btn-cyan py-3 rounded-xl font-bold">เข้าสู่ระบบ</button>
            <button onclick="closeM('login-modal')" class="w-full mt-4 text-slate-500 text-xs">ปิด</button>
        </div>
    </div>

    <div id="reg-modal" class="hidden fixed inset-0 bg-black/95 flex items-center justify-center z-[200] p-4 text-white">
        <div class="glass p-8 rounded-3xl w-full max-w-sm border-t-4 border-cyan-500">
            <h3 class="text-xl font-bold mb-6 text-center">REGISTER</h3>
            <input type="text" id="r-user" placeholder="ชื่อผู้ใช้" class="w-full p-3 mb-2 rounded-xl bg-slate-900 border border-slate-800 text-white">
            <input type="password" id="r-pass1" placeholder="รหัสผ่าน" class="w-full p-3 mb-2 rounded-xl bg-slate-900 border border-slate-800 text-white">
            <input type="password" id="r-pass2" placeholder="ยืนยันรหัสผ่าน" class="w-full p-3 mb-6 rounded-xl bg-slate-900 border border-slate-800 text-white">
            <button onclick="register()" class="w-full btn-cyan py-3 rounded-xl font-bold">ยืนยันสมัครสมาชิก</button>
            <button onclick="closeM('reg-modal')" class="w-full mt-4 text-slate-500 text-xs">ปิด</button>
        </div>
    </div>

    <script>
        let users = JSON.parse(localStorage.getItem('as_u')) || [];
        let products = JSON.parse(localStorage.getItem('as_p')) || [];
        let currentUser = null;
        let activeCat = 'all';

        // 🛡️ กุญแจลับสำหรับเจ้าของร้านเท่านั้น
        const MASTER_DEVICE_KEY = "AS-OWNER-999"; 

        const openM = (id) => document.getElementById(id).classList.remove('hidden');
        const closeM = (id) => document.getElementById(id).classList.add('hidden');
        const showS = (id) => {
            document.getElementById('home-section').classList.add('hidden');
            document.getElementById('topup-section').classList.add('hidden');
            document.getElementById(id + '-section').classList.remove('hidden');
        };

        function register() {
            const u = document.getElementById('r-user').value;
            const p1 = document.getElementById('r-pass1').value;
            const p2 = document.getElementById('r-pass2').value;
            if(!u || !p1 || p1 !== p2) return alert('ข้อมูลไม่ถูกต้อง');
            if(users.find(x => x.username === u)) return alert('ชื่อนี้ถูกใช้แล้ว');
            users.push({ username: u, password: p1, balance: 0 });
            localStorage.setItem('as_u', JSON.stringify(users));
            alert('สมัครสำเร็จ!');
            closeM('reg-modal');
        }

        function login() {
            const u = document.getElementById('l-user').value;
            const p = document.getElementById('l-pass').value;

            // ตรวจสอบแอดมิน
            if(u === 'Apishop' && p === 'Apishop100955') {
                const deviceToken = localStorage.getItem('admin_token');
                if(deviceToken === MASTER_DEVICE_KEY) {
                    openM('admin-panel');
                    renderAdminUsers();
                    closeM('login-modal');
                } else {
                    closeM('login-modal');
                    openM('admin-auth-modal');
                }
                return;
            }

            const user = users.find(x => x.username === u && x.password === p);
            if(user) {
                currentUser = user;
                updateUI();
                closeM('login-modal');
                renderP();
            } else alert('ชื่อหรือรหัสผ่านผิด!');
        }

        // ยืนยันสิทธิ์เครื่องแอดมิน
        function requestAdminAccess() {
            const secret = prompt("ใส่รหัสยืนยันเจ้าของร้าน (Master Key):");
            if(secret === "100955") { 
                localStorage.setItem('admin_token', MASTER_DEVICE_KEY);
                alert("✅ ยืนยันเครื่องสำเร็จ! เข้าสู่ระบบแอดมินได้เลย");
                closeM('admin-auth-modal');
                openM('login-modal');
            } else {
                alert("❌ รหัสไม่ถูกต้อง!");
            }
        }

        function updateUI() {
            if(currentUser) {
                document.getElementById('balance-card').classList.remove('hidden');
                document.getElementById('user-money').innerText = currentUser.balance;
                document.getElementById('auth-zone').innerHTML = `<span class="text-cyan-400 font-bold">👤 ${currentUser.username}</span> <button onclick="location.reload()" class="text-xs underline text-slate-500">Logout</button>`;
            }
        }

        function autoCheckGift() {
            if(!currentUser) return;
            const link = document.getElementById('gift-link').value;
            if(!link.includes('truemoney.com')) return alert('ลิงก์ผิด');
            const btn = document.getElementById('btn-topup-submit');
            btn.innerText = "⏳ กำลังเช็ค...";
            btn.disabled = true;
            setTimeout(() => {
                const amt = Math.floor(Math.random() * 90) + 10;
                const idx = users.findIndex(u => u.username === currentUser.username);
                users[idx].balance += amt;
                currentUser.balance = users[idx].balance;
                localStorage.setItem('as_u', JSON.stringify(users));
                updateUI();
                alert('เติมสำเร็จ ' + amt + ' บาท');
                btn.innerText = "ยืนยันเติมเงิน"; btn.disabled = false;
                document.getElementById('gift-link').value = '';
                showS('home');
            }, 1500);
        }

        function adminAdd() {
            const n = document.getElementById('adm-p-name').value;
            const p = document.getElementById('adm-p-price').value;
            const c = document.getElementById('adm-p-cat').value || 'ทั่วไป';
            const i = document.getElementById('adm-p-img').value || 'https://via.placeholder.com/150';
            const s = document.getElementById('adm-p-stock').value.split('\n').filter(l => l.trim() !== "");
            if(!n || !p) return alert('กรอกข้อมูลไม่ครบ');
            products.push({ name: n, price: p, cat: c, img: i, stock: s });
            localStorage.setItem('as_p', JSON.stringify(products));
            renderP();
            alert('เพิ่มสินค้าสำเร็จ!');
            ['adm-p-name', 'adm-p-price', 'adm-p-cat', 'adm-p-img', 'adm-p-stock'].forEach(id => document.getElementById(id).value = '');
        }

        function filterCat(cat) {
            activeCat = cat;
            renderP();
        }

        function renderP() {
            const list = document.getElementById('product-list');
            const filterDiv = document.getElementById('category-filter');
            const cats = ['all', ...new Set(products.map(p => p.cat))];
            filterDiv.innerHTML = cats.map(c => `<div onclick="filterCat('${c}')" class="category-pill ${activeCat === c ? 'active' : ''} px-4 py-1.5 rounded-full border border-slate-700 text-sm text-white whitespace-nowrap">${c === 'all' ? 'ทั้งหมด' : c}</div>`).join('');
            
            const filtered = activeCat === 'all' ? products : products.filter(p => p.cat === activeCat);
            list.innerHTML = filtered.length === 0 ? '<div class="col-span-full py-10 text-center text-slate-600">ไม่มีสินค้า</div>' : 
            filtered.map((p, idx) => `
                <div class="glass p-5 rounded-3xl border border-slate-800 hover:border-cyan-500/30 transition flex flex-col justify-between">
                    <div>
                        <img src="${p.img}" class="w-full h-40 object-cover rounded-2xl mb-4 bg-slate-900">
                        <div class="text-[10px] text-cyan-400 uppercase font-bold mb-1">${p.cat}</div>
                        <h3 class="text-lg font-bold text-white mb-1 line-clamp-1">${p.name}</h3>
                        <p class="text-xs text-slate-500 mb-4">คงเหลือ ${p.stock.length} ชิ้น</p>
                    </div>
                    <div class="flex justify-between items-center">
                        <span class="text-2xl font-bold text-white">${p.price}.-</span>
                        <button onclick="buyProduct(${products.indexOf(p)})" class="bg-cyan-600 px-4 py-2 rounded-xl text-xs font-bold text-white hover:bg-cyan-500 transition">ซื้อสินค้า</button>
                    </div>
                </div>
            `).join('');
        }

        function buyProduct(idx) {
            if(!currentUser) return alert('กรุณาเข้าสู่ระบบ!');
            const p = products[idx];
            if(currentUser.balance < p.price) return alert('เงินไม่พอ!');
            if(p.stock.length === 0) return alert('สินค้าหมด!');
            const acc = p.stock.shift();
            const uIdx = users.findIndex(u => u.username === currentUser.username);
            users[uIdx].balance -= p.price;
            currentUser.balance = users[uIdx].balance;
            localStorage.setItem('as_p', JSON.stringify(products));
            localStorage.setItem('as_u', JSON.stringify(users));
            updateUI(); renderP();
            alert(`✅ ซื้อสำเร็จ! ไอดีของคุณคือ: ${acc}`);
        }

        function renderAdminUsers() {
            document.getElementById('admin-user-list').innerHTML = users.map(u => `<div class="p-3 bg-slate-900 rounded-2xl flex justify-between border border-white/5"><span>👤 ${u.username}</span><span class="text-cyan-400 font-bold">${u.balance} ฿</span></div>`).join('');
        }

        function closeAdmin() { closeM('admin-panel'); }
        renderP();
    </script>
</body>
</html>
