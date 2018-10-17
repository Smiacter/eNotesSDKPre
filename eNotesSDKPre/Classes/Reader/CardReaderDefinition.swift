//
//  CardReaderDefinition.swift
//  eNotesSdk
//
//  Created by Smiacter on 2018/9/27.
//  Copyright © 2018 eNotes. All rights reserved.
//

/// NFC device master key, used to authenticate the deivce
//let MasterKey = "41 43 52 31 32 35 35 55 2D 4A 31 20 41 75 74 68"
let MasterKey = "41435231323535552D4A312041757468"

/// The data field of APDUs are encoded in SIMPLE-TLV which is defined in ISO/IEC 7816-4, Tag definition here
let TagDeviceCertificate = "30"
let TagDevicePrivateKey = "52"
let TagBlockChainPrivateKey = "54"
let TagBlockChainPublicKey = "55"
let TagChallenge = "70"
let TagSalt = "71"
let TagVerificationSignature = "73"
let TagTransactionSignatureCounter = "90"
let TagTransactionHash = "91"
let TagTransactionSignature = "92"

/// error in card read processing
///
/// none: everything is ok, on error there
/// deviceNotFound: no bluetooth or reader device found
/// absent: card absent status, now card should present on device to continue
/// parsing: card is in apdu parsing
/// apduReaderError: apdu command read error
/// verifyError: verify certificate, device or blockchain error
public enum CardReaderError {
    case none
    case deviceNotFound
    case absent
    case parsing
    case apduReaderError
    case verifyError
}

/// all apdu command
///
/// none: everything is ok, on error there
/// aid: Application id in device which you can identify your application to send apdu
/// publicKey: blockchain public key, get it by send apdu command
/// cardStatus: safe or danger
/// certificate: card certificate, need verify, get public key by 'call'(public key -> certificate private key)
///  - String: buffer offset index of device certificate, 0x00 ~ 0x07
/// verifyDevice: public key stored in card when 'verifyCertificate'(public key -> device private key)
/// verifyBlockchain: public key get from send 'publicKey' command(public key -> blockchain private key)
/// signPrivateKey: use transaction info(has been hashed) and private key(stored in device, nobody kown) to sign to get final transaction data
public enum Apdu: Equatable {
    case none
    case aid
    case publicKey
    case cardStatus
    case certificate(String)
    case verifyDevice
    case verifyBlockchain
    case signPrivateKey
    
    var value: String {
        switch self {
        case .none:
            return ""
        case .aid:
            return "00A404000C654e6f7465734170706c6574"
        case .publicKey:
            return "00CA0055"
        case .certificate(let p1):
            return "00CA0\(p1)30"
        case .cardStatus:
            return "00CA0090"
        case .verifyDevice:
            return "0088520022"
        case .verifyBlockchain:
            return "0088540022"
        case .signPrivateKey:
            return "00A0540022"
        }
    }
}
