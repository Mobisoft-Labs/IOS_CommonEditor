//
//  MEasingFunction.swift
//  MetalEngine
//
//  Created by IRIS STUDIO IOS on 30/07/23.
//

import Foundation

protocol MEasingFunction {
    func interpolate(_ input: Float) -> Float

}

extension MEasingFunction {
    func interpolate(_ input: Float) -> Float {
        return Float.zero
    }
}

struct EFCubicBezier : MEasingFunction {
    private var x1: Float
    private var y1: Float
    private var x2: Float
    private var y2: Float
    private let x0: Float = 0.0
    private let y0: Float = 0.0
    private let x3: Float = 1.0
    private let y3: Float = 1.0

    init(x1: Float, y1: Float, x2: Float, y2: Float) {
        self.x1 = x1
        self.y1 = y1
        self.x2 = x2
        self.y2 = y2
    }

    func interpolate(_ input: Float) -> Float {
        //return input
        if input == 0 {
            return 0
        }

        if input == 1 {
            return 1
        }

        var xu = input
        if xu < 0.0001 {
            xu = 0.0001
        }
      // return ease(xu)
        return value2(for :xu)
        
//        let u = calculateTime(input, x0: x0, x1: x1, x2: x2, x3: x3)
//        let yu = pow(1 - u, 3) * y0 + 3 * u * pow(1 - u, 2) * y1 + 3 * pow(u, 2) * (1 - u) * y2 + pow(u, 3) * y3
//
//        return yu
    }
    
    func value2(for t: Float) -> Float {
           let t1 = 1 - t
           let t1t1 = t1 * t1
           let t1t1t1 = t1t1 * t1
           let tt = t * t
           let ttt = tt * t

           let x = x0 * t1t1t1 + 3 * x1 * t * t1t1 + 3 * x2 * tt * t1 + x3 * ttt
           let y = y0 * t1t1t1 + 3 * y1 * t * t1t1 + 3 * y2 * tt * t1 + y3 * ttt

           return y
       }
    
    func value(for t: Float) -> Float {
          let t1 = 1 - t
          let t2 = t * t
          let t3 = t2 * t
          let t1t1 = t1 * t1
          let t1t1t1 = t1t1 * t1
          let t2t2 = t2 * t2
          let t3t3 = t3 * t3
          return x0 * t1t1t1 + 3 * x1 * t * t1t1 + 3 * x2 * t2 * t1 + x3 * t3t3
      }
    

    
    func ease(_ t: Float) -> Float {
            let cx = 3.0 * x0
            let bx = 3.0 * (x2 - x0) - cx
            let ax = 1.0 - cx - bx

            let cy = 3.0 * x1
            let by = 3.0 * (x3 - x1) - cy
            let ay = 1.0 - cy - by

            let tSquared = t * t
            let tCubed = tSquared * t

            let x = (ax * tCubed) + (bx * tSquared) + (cx * t)
            let y = (ay * tCubed) + (by * tSquared) + (cy * t)

            return y*x
        }

    private func calculateTime(_ tinput: Float, x0: Float, x1: Float, x2: Float, x3: Float) -> Float {
        var roots: [Float] = [0.0, 0.0, 0.0]
        findRoots(tinput, x0: x0, x1: x1, x2: x2, x3: x3, roots: &roots)
        var t: Float = 0.0
        for root in roots {
            if root >= 0, root <= 1 {
                t = root
                break
            }
        }
        return t
    }

    private func approximately(_ a: Float, _ b: Float) -> Bool {
        return abs(a - b) < 0.000001
    }

    private func crt(_ x: Float) -> Float {
        return x < 0 ? -pow(-x, 1.0 / 3.0) : pow(x, 1.0 / 3.0)
    }

    private func findRoots(_ x: Float, x0: Float, x1: Float, x2: Float, x3: Float, roots: inout [Float]) {
        let XM_PI = Float.pi
        let TAU = XM_PI * 2.0
        let pa3 = 3 * x1
        let pb3 = 3 * x2
        let pc3 = 3 * x3
        var a = -x1 + pb3 - pc3 + x3
        var b = pa3 - 2 * pb3 + pc3
        var c = -pa3 + pb3
        var d = x0 - x

        if approximately(a, 0) {
            if approximately(b, 0) {
                if approximately(c, 0) {
                    return
                }
                // linear solution:
                roots[0] = -d / c
                return
            }
            // quadratic solution:
            let Loaclq = sqrt(c * c - 4 * b * d)
            let b2 = 2 * b
            roots[0] = (Loaclq - c) / b2
            roots[1] = (-c - Loaclq) / b2
            return
        }

        b /= a
        c /= a
        d /= a

        let b3 = b / 3
        let p = (3 * c - b * b) / 3
        let p3 = p / 3
        let q = (2 * b * b * b - 9 * b * c + 27 * d) / 27
        let q2 = q / 2
        let discriminant = q2 * q2 + p3 * p3 * p3
        var u1, v1: Float

        if discriminant < 0 {
            let mp3 = -p / 3
            let r = sqrt(mp3 * mp3 * mp3)
            let t = -q / (2 * r)
            let cosphi = t < -1 ? -1 : t > 1 ? 1 : t
            let phi = acos(cosphi)
            let crtr = crt(r)
            let t1 = 2 * crtr

            roots[0] = t1 * cos(phi / 3) - b3
            roots[1] = t1 * cos((phi + TAU) / 3) - b3
            roots[2] = t1 * cos((phi + 2 * TAU) / 3) - b3

            return
        } else if discriminant == 0 {
            u1 = q2 < 0 ? crt(-q2) : -crt(q2)
            roots[0] = 2 * u1 - b3
            roots[1] = -u1 - b3
            return
        } else {
            let sd = sqrt(discriminant)
            u1 = crt(-q2 + sd)
            v1 = crt(q2 + sd)
            roots[0] = u1 - v1 - b3
            return
        }
    }
}

