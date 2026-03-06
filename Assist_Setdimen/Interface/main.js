// main.js – WORLD + VIP (รวมในลิสต์เดียว)
// ---------------------------------------------------
// โครงสร้างที่ฝั่ง Lua ส่งเข้ามา:
// SendNUIMessage({
//   action: "showMenu",
//   zone: {
//     text: "MINER",               // ชื่อหัวข้อ
//     dimension: [1,2,3,...],      // WORLD ปกติ
//     dimensionVip: { dimension: [11,12,13], checkItem: "vip_card" } // (ออปชัน)
//     // หรือ zone.vip = { dimension: [...] } ก็ได้
//   },
//   currentDimension: 0|<เลขมิติจริง>
// })
// ---------------------------------------------------

$(function () {
  // ถ้ายังไม่มี container-world ใน DOM ให้สร้างอัตโนมัติ
  if ($(".container-world").length === 0) {
    $("body").append(`
      <div class="container-world" style="display:none;">
        <div class="world-title">
          <iconify-icon icon="streamline-plump:world-solid"></iconify-icon>
          <span>มิติ</span>
        </div>
        <div class="world-img">
          <div class="world-main dropdown-toggle">MAIN</div>
        </div>
        <div class="world-list" style="display:none;"></div>
        <div class="world-button" data-worldid="0"><span>JOIN !</span></div>
      </div>
    `);
  }

  const RES = (typeof GetParentResourceName === "function")
    ? GetParentResourceName()
    : "nui"; // เผื่อดีบักนอกเกม

  let isJoining = false;
  let selectedWorldId = 0;

  // label ปุ่มหลักตาม currentDimension (รองรับ VIP)
  function getLabelForCurrent(normDims, vipDims, currentDim) {
    if (!Number.isFinite(currentDim) || currentDim === 0) return "MAIN";
    if (vipDims.length) {
      const idxVip = vipDims.indexOf(currentDim);
      if (idxVip >= 0) return `VIP ${idxVip + 1}`;
    }
    if (normDims.length) {
      const idx = normDims.indexOf(currentDim);
      if (idx >= 0) return `WORLD ${idx + 1}`;
    }
    return "MAIN";
  }

  // worldid เริ่มต้นที่ต้อง active
  function getStartWorldId(normDims, vipDims, currentDim) {
    if (!Number.isFinite(currentDim) || currentDim === 0) return 0;
    if (vipDims.includes(currentDim)) return currentDim;
    if (normDims.includes(currentDim)) return currentDim;
    return 0;
  }

  // เรนเดอร์เมนูจาก zone + currentDimension
  function renderMenu(zoneData, currentDimension) {
    const titleText = (zoneData && zoneData.text) ? zoneData.text : "มิติ";

    // ✅ บังคับ Number ให้หมด เพื่อให้ indexOf ตรงเสมอ
    const normDims = Array.isArray(zoneData?.dimension)
      ? zoneData.dimension.map(n => Number(n)).filter(Number.isFinite)
      : [];

    const vipDimsRaw =
      Array.isArray(zoneData?.vip?.dimension) ? zoneData.vip.dimension :
      (Array.isArray(zoneData?.dimensionVip?.dimension) ? zoneData.dimensionVip.dimension : []);
    const vipDims = Array.isArray(vipDimsRaw)
      ? vipDimsRaw.map(n => Number(n)).filter(Number.isFinite)
      : [];

    const curDim = Number(currentDimension) || 0;

    $(".world-title span").text(titleText);

    const $list = $(".world-list");
    $list.empty();

    // MAIN (world 0)
    $list.append(`
      <div class="world-box" data-worldid="0">
        <span>MAIN</span>
      </div>
    `);

    // WORLD 1..N (ปกติ)
    normDims.forEach((realDim, i) => {
      const displayNum = i + 1;
      $list.append(`
        <div class="world-box" data-worldid="${realDim}">
          <span>WORLD ${displayNum}</span>
        </div>
      `);
    });

    // VIP 1..M (ต่อท้ายในลิสต์เดียวกัน, ไม่มี header แยก)
    if (vipDims.length > 0) {
      vipDims.forEach((realDim, i) => {
        const displayNum = i + 1;
        $list.append(`
          <div class="world-box vip" data-worldid="${realDim}">
            <span>VIP ${displayNum}</span>
          </div>
        `);
      });
    }

    // ✅ กำหนด label/active ตาม curDim (ไม่รีเซ็ตเป็น MAIN ถ้าอยู่ world อื่น)
    const startLabel   = getLabelForCurrent(normDims, vipDims, curDim);
    const startWorldId = getStartWorldId(normDims, vipDims, curDim);

    $(".world-main").text(startLabel);
    $(".world-button").data("worldid", startWorldId).attr("data-worldid", startWorldId);

    $(".world-box").removeClass("active");
    const $active = $(`.world-box[data-worldid="${startWorldId}"]`).addClass("active");

    selectedWorldId = startWorldId;

    // เลื่อนสกอลล์ให้ item ที่ active อยู่ในวิว (สวยขึ้น)
    const listEl = $list.get(0);
    const itemEl = $active.get(0);
    if (listEl && itemEl) {
      listEl.scrollTop = itemEl.offsetTop - Math.max(0, listEl.clientHeight - itemEl.clientHeight) / 3;
    }

    $(".world-list").hide();
    $(".container-world").fadeIn(200);
    isJoining = false;
  }

  // รับข้อความจาก Lua
  window.addEventListener("message", function (event) {
    const data = event.data;
    if (!data || !data.action) return;

    if (data.action === "showMenu") {
      const currentDim = Number(data.currentDimension) || 0;
      renderMenu(data.zone || {}, currentDim);
    }

    if (data.action === "hideMenu") {
      $(".container-world").fadeOut(200);
    }
  });

  // เปิด/ปิด dropdown
  $(".world-main").on("click", function () {
    $(".world-list").fadeToggle(160);
  });

  // เลือกรายการ (MAIN / WORLD X / VIP X)
  $(document).on("click", ".world-box", function () {
    const worldid = Number($(this).data("worldid")) || 0;
    const label   = $(this).find("span").first().text();

    // อัปเดตปุ่มหลักและค่า JOIN (เซ็ตทั้ง data และ attr กัน cache)
    $(".world-main").text(label);
    $(".world-button").data("worldid", worldid).attr("data-worldid", worldid);

    $(".world-box").removeClass("active");
    $(this).addClass("active");

    selectedWorldId = worldid;
    $(".world-list").fadeOut(160);

    console.log(`[Dimension] Selected worldid: ${selectedWorldId}`);
  });

  // JOIN
  $(".world-button").on("click", function () {
    if (isJoining) return;
    isJoining = true;

    const worldid = Number($(this).data("worldid")) || 0;

    $(".container-world").fadeOut(200);

    $.post(`https://${RES}/joinWorld`, JSON.stringify({ worldid }))
      .always(function () {
        console.log(`[Dimension] Request to join world ${worldid}`);
        $.post(`https://${RES}/closeUI`, JSON.stringify({}));
        isJoining = false;
      });
  });

  // ESC ปิด UI
  $(document).on("keyup", function (e) {
    if (e.key === "Escape") {
      $(".container-world").fadeOut(200);
      $.post(`https://${RES}/closeUI`, JSON.stringify({}));
    }
  });
});
