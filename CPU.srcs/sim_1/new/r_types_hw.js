function compareSigned(a, b) {
    const signedA = a | 0;
    const signedB = b | 0;
    return signedA === signedB ? 0 : (signedA < signedB ? -1 : 1);
}

function compareUnsigned(a, b) {
    const unsignedA = a >>> 0;
    const unsignedB = b >>> 0;
    return unsignedA === unsignedB ? 0 : (unsignedA < unsignedB ? -1 : 1);
}

let x5 = 0 + 5;
console.log(`x5 = 0 + 5: 0x${(x5 >>> 0).toString(16)}`);

let x6 = x5 - 10;
console.log(`x6 = x5 - 10: 0x${(x6 >>> 0).toString(16)}`);

let x7 = x6 + 3;
console.log(`x7 = x6 + 3: 0x${(x7 >>> 0).toString(16)}`);

let x28 = x5 + x6;
console.log(`x28 = x5 + x6: 0x${(x28 >>> 0).toString(16)}`);

let x29 = x6 - x7;
console.log(`x29 = x6 - x7: 0x${(x29 >>> 0).toString(16)}`);

x5 = x5 << x5;
console.log(`x5 = x5 << x5: 0x${(x5 >>> 0).toString(16)}`);

let x31 = x7 >>> x29;
console.log(`x31 = x7 >>> x29: 0x${(x31 >>> 0).toString(16)}`);

let x30 = x29 >> x28;
console.log(`x30 = x29 >> x28: 0x${(x30 >>> 0).toString(16)}`);

x29 = x7 | x7;
console.log(`x29 = x7 | x7: 0x${(x29 >>> 0).toString(16)}`);

x28 = x30 & x31;
console.log(`x28 = x30 & x31: 0x${(x28 >>> 0).toString(16)}`);

x7 = x29 ^ x6;
console.log(`x7 = x29 ^ x6: 0x${(x7 >>> 0).toString(16)}`);

x30 = compareSigned(x28, x7) === -1;
console.log(`x30 = x28 < x7 (signed): ${x30}`);

x30 = compareUnsigned(x7, x28) === -1;
console.log(`x30 = x7 < x28 (unsigned): ${x30}`);

