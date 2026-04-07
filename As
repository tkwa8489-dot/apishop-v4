<!DOCTYPE html>
<html lang="th">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apishop - Ultimate V5 (Fixed)</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Kanit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { font-family: 'Kanit', sans-serif; box-sizing: border-box; }
        body { background-color: #020617; color: #e2e8f0; margin: 0; min-height: 100vh; }
        .glass { background: rgba(15, 23, 42, 0.8); backdrop-filter: blur(12px); border: 1px solid rgba(255,255,255,0.05); }
        .btn-cyan { background: linear-gradient(45deg, #0891b2, #06b6d4); border: none; cursor: pointer; color: white; transition: 0.3s; }
        .btn-cyan:hover { filter: brightness(1.2); transform: translateY(-2px); }
        .hidden { display: none !important; }
        .category-pill { cursor: pointer; transition: 0.2s; border: 1px solid rgba(255,255,255,0.1); }
        .category-pill.active { background-color: #06b6d4; color: white; border-color: #06b6d4; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
    </style>
</head>
<body>

    <nav class="p-4 glass sticky top-0 z-50 flex justify-between items-center border-b border-cyan-900/30">
        <div class="flex items-center gap-3 cursor-pointer" onclick="location.reload()">
            <div class="p-2 bg-cyan-500 rounded-lg text-white font-bold">AS</div>
            <h1 class="text-xl font-bold text-white tracking-tighter">Apishop</h1>
        </div>
        <div id="auth-zone" class="flex gap-2 text-sm">
            <button onclick="openM('login-modal')" class="text-white px-2 hover:text-cyan-400">เข้าสู่ระบบ</button>
            <button onclick="openM('reg-modal')" class="btn-cyan px-5 py-1.5 rounded-full font-semibold">สมัครสมาชิก</button>
        </div>
    </nav>

    <main class="container mx-auto p-4 md:p-6">
        <div id="balance-card" class="hidden mb-8 p-6 glass rounded-3xl flex justify-between items-center border-l-8 border-cyan-500">
            <div>
                <p class="text-slate-400 text-xs">ยอดเงินคงเหลือ</p>
                <h2 class="text-3xl font-bold text-white"><span id="user-money">0</span> <span class="text-cyan-500 text-sm">฿</span></h2>
            </div>
            <div class="flex gap-2">
                <button onclick="showS('history')" class="bg-slate-800 text-white px-4 py-2 rounded-xl text-xs hover:bg-slate-700">📜 ประวัติซื้อ</button>
                <button onclick="showS('topup')" class="bg-cyan-600 text-white px-6 py-2 rounded-xl text-xs font-bold hover:bg-cyan-500">➕ เติมเงิน</button>
            </div>
        </div>

        <section id="home-section">
            <div class="flex flex-col md:flex-row justify-between items-center mb-6 gap-4">
                <h2 class="text-xl font-bold text-white flex items-center gap-2"><span class="w-1.5 h-6 bg-cyan-500 rounded-full"></span> สินค้าแนะนำ</h2>
                <div id="category-filter" class="flex gap-2 overflow-x-auto pb-2 w-full md:w-auto no-scrollbar"></div>
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
                <button id="btn-topup-submit" onclick="autoCheckGift()" class="w-full py-4 rounded-2xl bg-gradient-to-r from-pink-600 to-orange-500 font-bold text-white">ยืนยันเติมเงิน</button>
                <button onclick="showS('home')" class="mt-4 text-slate-500 text-sm block w-full hover:underline">ยกเลิก</button>
            </div>
        </section>
    </main>

    <div id="admin-panel" class="hidden fixed inset-0 bg-[#020617] z-[100] overflow-y-auto p-4 md:p-8">
        <div class="max-w-7xl mx-auto">
            <div class="flex justify-between items-center mb-8 border-b border-white/10 pb-6">
                <h1 class="text-2xl font-bold text-red-500 italic">ADMIN CONSOLE</h1>
                <button onclick="closeAdmin()" class="bg-slate-800 px-6 py-2 rounded-xl text-white">ปิดระบบ</button>
            </div>
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <div class="glass p-6 rounded-2xl">
                    <h3 class="text-cyan-400 font-bold mb-4">📦 ลงสินค้า/หมวดหมู่</h3>
                    <div class="space-y-3">
                        <input type="text" id="adm-p-name" placeholder="ชื่อสินค้า" class="w-full p-3 rounded-xl bg-slate-900 border border-slate-700 text-white">
                        <input type="number" id="adm-p-price" placeholder="ราคา" class="w-full p-3 rounded-xl bg-slate-900 border border-slate-700 text-white">
                        <input type="text" id="adm-p-cat" placeholder="หมวดหมู่" class="w-full p-3 rounded-xl bg-slate-900 border border-slate-700 text-white">
                        <input type="text" id="adm-p-img" placeholder="URL รูป" class="w-full p-3 rounded-xl bg-slate-900 border border-slate-700 text-white">
                        <textarea id="adm-p-stock" placeholder="ไอดี:รหัส (1 บรรทัด ต่อ 1 ไอดี)" class="w-full p-3 rounded-xl bg-slate-900 border border-slate-700 h-32 text-white text-xs"></textarea>
                        <button onclick="adminAdd()" class="w-full bg-cyan-600 py-3 rounded-xl font-bold text-white">ลงขาย</button>
                    </div>
                </div>
                <div class="glass p-6 rounded-2xl overflow-y-auto max-h-[500px]">
                    <h3 class="text-green-400 font-bold mb-4">🔄 เติมสต็อกสินค้า</h3>
                    <div id="admin-inventory-list" class="space-y-3"></div>
                </div>
                <div class="glass p-6 rounded-2xl overflow-y-auto max-h-[500px]">
                    <h3 class="text-yellow-400 font-bold mb-4">👤 สมาชิก</h3>
                    <div id="admin-user-list" class="space-y-3"></div>
                </div>
            </div>
        </div>
    </div>

    <div id="login-modal" class="hidden fixed inset-0 bg-black/90 flex items-center justify-center z-[200] p-4">
        <div class="glass p-8 rounded-3xl w-full max-w-sm border-t-4 border-cyan-500">
            <h3 class="text-xl font-bold mb-6 text-center text-white uppercase">LOGIN</h3>
            <input type="text" id="l-user" placeholder="Username" class="w-full p-3 mb-3 rounded-xl bg-slate-900 border border-slate-700 text-white">
            <input type="password" id="l-pass" placeholder="Password" class="w-full p-3 mb-6 rounded-xl bg-slate-900 border border-slate-700 text-white">
            <button onclick="login()" class="w-full btn-cyan py-3 rounded-xl font-bold">เข้าสู่ระบบ</button>
            <button onclick="closeM('login-modal')" class="w-full mt-4 text-slate-500 text-xs">ปิด</button>
        </div>
    </div>

    <div id="reg-modal" class="hidden fixed inset-0 bg-black/90 flex items-center justify-center z-[200] p-4">
        <div class="glass p-8 rounded-3xl w-full max-w-sm border-t-4 border-cyan-500">
            <h3 class="text-xl font-bold mb-6 text-center text-white uppercase">REGISTER</h3>
            <input type="text" id="r-user" placeholder="Username" class="w-full p-3 mb-3 rounded-xl bg-slate-900 border border-slate-700 text-white">
            <input type="password" id="r-pass1" placeholder="Password" class="w-full p-3 mb-3 rounded-xl bg-slate-900 border border-slate-700 text-white">
            <input type="password" id="r-pass2" placeholder="Confirm Password" class="w-full p-3 mb-6 rounded-xl bg-slate-900 border border-slate-700 text-white">
            <button onclick="register()" class="w-full btn-cyan py-3 rounded-xl font-bold">สมัครสมาชิก</button>
            <button onclick="closeM('reg-modal')" class="w-full mt-4 text-slate-500 text-xs">ปิด</button>
        </div>
    </div>

    <div id="success-modal" class="hidden fixed inset-0 bg-black/95 flex items-center justify-center z-[400] p-4">
        <div class="glass p-8 rounded-3xl w-full max-w-sm text-center border-t-4 border-green-500">
            <h3 class="text-xl font-bold mb-2 text-white">ซื้อสำเร็จ! ✅</h3>
            <p class="text-slate-400 text-xs mb-4 uppercase">ข้อมูลไอดีของท่าน</p>
            <div class="bg-slate-900 p-4 rounded-xl mb-4 border border-slate-800">
                <input type="text" id="acc-out" readonly class="w-full bg-transparent text-cyan-400 font-bold text-center outline-none">
            </div>
            <button onclick="copyAcc()" class="w-full bg-cyan-600 py-2 rounded-xl text-white font-bold mb-4">คัดลอกรหัส</button>
            <button onclick="closeM('success-modal')" class="text-slate-500 text-xs">ปิดหน้าต่างนี้</button>
        </div>
    </div>

    <script>
        // ข้อมูลเบื้องต้น
        let users = JSON.parse(localStorage.getItem('as_u')) || [];
        let products = JSON.parse(localStorage.getItem('as_p')) || [];
        let currentUser = null;
        let activeCat = 'all';

        // พื้นฐาน UI
        const openM = (id) => document.getElementById(id).classList.remove('hidden');
        const closeM = (id) => document.getElementById(id).classList.add('hidden');
        const showS = (id) => {
            ['home', 'topup', 'history'].forEach(s => document.getElementById(s + '-section').classList.add('hidden'));
            document.getElementById(id + '-section').classList.remove('hidden');
            if(id === 'history') renderHistory();
        };

        // --- ระบบซื้อขาย ---
        function register() {
            const u = document.getElementById('r-user').value;
            const p1 = document.getElementById('r-pass1').value;
            const p2 = document.getElementById('r-pass2').value;
            if(!u || !p1 || p1 !== p2) return alert('ข้อมูลไม่ถูกต้อง');
            if(users.find(x => x.username === u)) return alert('มีชื่อนี้แล้ว');
            users.push({ username: u, password: p1, balance: 0, orders: [] });
            saveU(); alert('สมัครแล้ว!'); closeM('reg-modal');
        }

        function login() {
            const u = document.getElementById('l-user').value;
            const p = document.getElementById('l-pass').value;
            if(u === 'Apishop' && p === 'Apishop100955') {
                const check = localStorage.getItem('admin_token');
                if(check === "LOCK") { openM('admin-panel'); renderAdmin(); closeM('login-modal'); return; }
                const k = prompt("Master Key:");
                if(k === "100955") { localStorage.setItem('admin_token', "LOCK"); openM('admin-panel'); renderAdmin(); closeM('login-modal'); }
                else alert('ผิด!'); return;
            }
            const user = users.find(x => x.username === u && x.password === p);
            if(user) { currentUser = user; updateUI(); closeM('login-modal'); renderP(); }
            else alert('รหัสผิด!');
        }

        function buyProduct(idx) {
            if(!currentUser) return alert('เข้าสู่ระบบก่อน!');
            const p = products[idx];
            if(currentUser.balance < p.price) return alert('เงินไม่พอ!');
            if(p.stock.length === 0) return alert('หมด!');
            
            const acc = p.stock.shift();
            const uIdx = users.findIndex(u => u.username === currentUser.username);
            users[uIdx].balance -= p.price;
            if(!users[uIdx].orders) users[uIdx].orders = [];
            users[uIdx].orders.unshift({ name: p.name, account: acc, date: new Date().toLocaleString() });
            
            currentUser = users[uIdx];
            saveU(); saveP(); updateUI(); renderP();
            document.getElementById('acc-out').value = acc;
            openM('success-modal');
        }

        // --- ระบบ ADMIN ---
        function adminAdd() {
            const n = document.getElementById('adm-p-name').value;
            const p = parseInt(document.getElementById('adm-p-price').value);
            const c = document.getElementById('adm-p-cat').value || 'ทั่วไป';
            const img = document.getElementById('adm-p-img').value || 'https://via.placeholder.com/150';
            const s = document.getElementById('adm-p-stock').value.split('\n').filter(l => l.trim() !== "");
            if(!n || !p) return alert('กรอกข้อมูล!');
            products.push({ id: Date.now(), name: n, price: p, cat: c, img: img, stock: s });
            saveP(); renderP(); renderAdmin(); alert('เพิ่มแล้ว!');
            ['adm-p-name', 'adm-p-price', 'adm-p-cat', 'adm-p-img', 'adm-p-stock'].forEach(id => document.getElementById(id).value = '');
        }

        function restock(pid) {
            const extra = prompt("ไอดี:รหัส (1 บรรทัด ต่อ 1 อัน):");
            if(!extra) return;
            const idx = products.findIndex(x => x.id === pid);
            products[idx].stock = [...products[idx].stock, ...extra.split('\n').filter(l => l.trim() !== "")];
            saveP(); renderP(); renderAdmin();
        }

        function editMoney(uName) {
            const m = prompt(`เพิ่ม/ลดเงินให้ ${uName}:`);
            if(!m || isNaN(m)) return;
            const idx = users.findIndex(u => u.username === uName);
            users[idx].balance += parseInt(m);
            saveU(); renderAdmin();
            if(currentUser && currentUser.username === uName) { currentUser.balance = users[idx].balance; updateUI(); }
        }

        // --- เรนเดอร์ต่างๆ ---
        function renderP() {
            const list = document.getElementById('product-list');
            const cats = ['all', ...new Set(products.map(p => p.cat))];
            document.getElementById('category-filter').innerHTML = cats.map(c => `<div onclick="filterCat('${c}')" class="category-pill ${activeCat === c ? 'active' : ''} px-4 py-1.5 rounded-full text-xs text-white whitespace-nowrap">${c === 'all' ? 'ทั้งหมด' : c}</div>`).join('');
            
            const filtered = activeCat === 'all' ? products : products.filter(p => p.cat === activeCat);
            list.innerHTML = filtered.map((p, i) => `
                <div class="glass p-5 rounded-3xl border border-slate-800 flex flex-col justify-between">
                    <div>
                        <img src="${p.img}" class="w-full h-32 object-cover rounded-2xl mb-4 bg-slate-900">
                        <p class="text-[10px] text-cyan-400 font-bold uppercase">${p.cat}</p>
                        <h3 class="text-white font-bold mb-1">${p.name}</h3>
                        <p class="text-xs text-slate-500 mb-4 italic">สต็อก: ${p.stock.length}</p>
                    </div>
                    <div class="flex justify-between items-center">
                        <span class="text-xl font-bold text-white">${p.price} ฿</span>
                        <button onclick="buyProduct(${products.indexOf(p)})" class="bg-cyan-600 px-4 py-2 rounded-xl text-xs font-bold text-white">ซื้อ</button>
                    </div>
                </div>
            `).join('');
        }

        function renderAdmin() {
            document.getElementById('admin-inventory-list').innerHTML = products.map(p => `
                <div class="p-3 bg-slate-900 rounded-xl flex justify-between items-center border border-white/5">
                    <span class="text-xs font-bold truncate w-24">${p.name}</span>
                    <button onclick="restock(${p.id})" class="bg-green-600 text-white px-2 py-1 rounded text-[10px]">เติมของ</button>
                    <button onclick="delP(${p.id})" class="bg-red-900 text-white px-2 py-1 rounded text-[10px]">ลบ</button>
                </div>`).join('');
            document.getElementById('admin-user-list').innerHTML = users.map(u => `
                <div class="p-3 bg-slate-900 rounded-xl border border-white/5 space-y-2">
                    <div class="flex justify-between text-xs"><span>👤 ${u.username}</span><span class="text-cyan-400">${u.balance} ฿</span></div>
                    <button onclick="editMoney('${u.username}')" class="w-full bg-white/5 py-1 rounded text-[10px] text-white">เพิ่ม/ลดเงิน</button>
                </div>`).join('');
        }

        function renderHistory() {
            const list = document.getElementById('order-history-list');
            if(!currentUser.orders || currentUser.orders.length === 0) return list.innerHTML = '<p class="text-center text-slate-500">ไม่มีประวัติ</p>';
            list.innerHTML = currentUser.orders.map(o => `
                <div class="glass p-4 rounded-2xl border border-white/5">
                    <p class="text-[10px] text-slate-500">${o.date}</p>
                    <h4 class="font-bold text-white text-sm">${o.name}</h4>
                    <p class="text-cyan-400 text-xs font-mono mt-2 bg-black/30 p-2 rounded-lg">ID: ${o.account}</p>
                </div>`).join('');
        }

        function autoCheckGift() {
            if(!currentUser) return;
            const l = document.getElementById('gift-link').value;
            if(!l.includes('truemoney.com')) return alert('ลิงก์ผิด');
            const btn = document.getElementById('btn-topup-submit');
            btn.innerText = "กำลังตรวจสอบ..."; btn.disabled = true;
            setTimeout(() => {
                const amt = Math.floor(Math.random() * 90) + 10;
                const idx = users.findIndex(u => u.username === currentUser.username);
                users[idx].balance += amt; currentUser = users[idx];
                saveU(); updateUI(); alert(`เติมแล้ว ${amt} ฿`);
                btn.innerText = "ยืนยันเติมเงิน"; btn.disabled = false;
                document.getElementById('gift-link').value = ''; showS('home');
            }, 1500);
        }

        function copyAcc() { const out = document.getElementById('acc-out'); out.select(); document.execCommand('copy'); alert('ก๊อปปี้แล้ว!'); }
        function updateUI() { 
            if(currentUser) { 
                document.getElementById('balance-card').classList.remove('hidden'); 
                document.getElementById('user-money').innerText = currentUser.balance; 
                document.getElementById('auth-zone').innerHTML = `<p class="text-cyan-400 font-bold">${currentUser.username}</p><button onclick="location.reload()" class="text-red-500 text-xs">Logout</button>`;
            } 
        }
        function saveP() { localStorage.setItem('as_p', JSON.stringify(products)); }
        function saveU() { localStorage.setItem('as_u', JSON.stringify(users)); }
        function filterCat(c) { activeCat = c; renderP(); }
        function delP(pid) { products = products.filter(x => x.id !== pid); saveP(); renderP(); renderAdmin(); }
        function closeAdmin() { closeM('admin-panel'); }

        renderP();
    </script>
</body>
</html>
