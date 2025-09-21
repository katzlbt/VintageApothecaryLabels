function offsetPath(offset) {
    let rw = 200, rh = 100;  // rectangle
    let edge = 13.5;        // slanted edge
    var p0x = edge, p0y = 0;

    // MODIFIED LINE: Calculate 'a' to be a signed value.
    // This allows 'a' to be negative for outsets (negative offset).
    let a = offset / Math.sqrt(2);
    console.log(a);
    
    // The rest of the logic works correctly with a signed 'a'.
    p0x += a;
    p0y += offset + a / 2;

    let mm = edge + a;
    let md = edge - a;
    let my = 100 - 2 * mm;
    let mx = 200 - 2 * mm;

    let path1 = `M ${p0x},${p0y}
      l ${mx},0
      l ${md},${md}
      l 0,${my}
      l -${md},${md}
      l -${mx},0
      l -${md},-${md}
      l 0,-${my}
      z`;

    return path1;
}


// Apothecary Laser-Label thick line
console.log(offsetPath(0));
console.log(offsetPath(2.1));

// Apothecary Laser-Label thin line
console.log(offsetPath(4.4));
console.log(offsetPath(4.8));

// Apothecary Laser-Label cutting line
