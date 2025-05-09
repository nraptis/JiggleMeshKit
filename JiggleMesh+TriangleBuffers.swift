//
//  JiggleMesh+TriangleBuffers.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 7/9/24.
//

import Foundation
import RenderKit

public extension JiggleMesh {
    
    func refreshTriangleBufferEditStandard(isSelected: Bool, 
                                           isFrozen: Bool,
                                           isDarkMode: Bool,
                                           opacityPercent: Float) {
        editBufferStandardRegular.reset()
        for indexIndex in 0..<indexCount {
            editBufferStandardRegular.add(index: indices[indexIndex])
        }
        
        editBufferStandardPrecise.reset()
        for indexIndex in 0..<indexCount {
            editBufferStandardPrecise.add(index: indices[indexIndex])
        }
        
        let alpha: Float
        if isFrozen {
            alpha = 0.07 + 0.300 * opacityPercent
        } else {
            if isSelected {
                alpha = 0.10 + 0.400 * opacityPercent
            } else {
                alpha = 0.07 + 0.300 * opacityPercent
            }
        }
        
        var red: Float
        var green: Float
        var blue: Float
        
        if isFrozen {
            if isDarkMode {
                red = RTJ.jiggleFillDarkFrozen.red
                green = RTJ.jiggleFillDarkFrozen.green
                blue = RTJ.jiggleFillDarkFrozen.blue
            } else {
                red = RTJ.jiggleFillLightFrozen.red
                green = RTJ.jiggleFillLightFrozen.green
                blue = RTJ.jiggleFillLightFrozen.blue
            }
        } else {
            if isDarkMode {
                red = RTJ.jiggleFillDark0.red
                green = RTJ.jiggleFillDark0.green
                blue = RTJ.jiggleFillDark0.blue
            } else {
                red = RTJ.jiggleFillLight0.red
                green = RTJ.jiggleFillLight0.green
                blue = RTJ.jiggleFillLight0.blue
            }
        }
        
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
            let vertex = Shape2DColoredVertex(x: jiggleMeshPoint.transformedX,
                                                        y: jiggleMeshPoint.transformedY,
                                                        r: red,
                                                        g: green,
                                                        b: blue,
                                                        a: alpha)
            editBufferStandardRegular.add(vertex: vertex)
        }
        
        
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
            let vertex = Shape2DColoredVertex(x: jiggleMeshPoint.transformedX,
                                                        y: jiggleMeshPoint.transformedY,
                                                        r: red,
                                                        g: green,
                                                        b: blue,
                                                        a: alpha)
            editBufferStandardPrecise.add(vertex: vertex)
        }
    }
    
    func refreshTriangleBufferEditWeights(isSelected: Bool,
                                          isFrozen: Bool,
                                          isDarkMode: Bool,
                                          sortedGuideCount: Int,
                                          opacityPercent: Float) {
        
        
        let alpha: Float
        if isFrozen {
            alpha = 0.07 + 0.300 * opacityPercent
        } else {
            if isSelected {
                alpha = 0.10 + 0.400 * opacityPercent
            } else {
                alpha = 0.07 + 0.300 * opacityPercent
            }
        }
        
        editBufferWeightsRegular.reset()
        for indexIndex in 0..<indexCount {
            editBufferWeightsRegular.add(index: indices[indexIndex])
        }
        
        editBufferWeightsPrecise.reset()
        for indexIndex in 0..<indexCount {
            editBufferWeightsPrecise.add(index: indices[indexIndex])
        }
        
        
        let ceiling = (sortedGuideCount + 1)
        
        if isFrozen {
            if isDarkMode {
                for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
                    let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
                    let red = RTJ.jiggleFillDarkFrozen.red
                    let green = RTJ.jiggleFillDarkFrozen.green
                    let blue = RTJ.jiggleFillDarkFrozen.blue
                    let vertex = Shape2DColoredVertex(x: jiggleMeshPoint.transformedX,
                                                                y: jiggleMeshPoint.transformedY,
                                                                r: red,
                                                                g: green,
                                                                b: blue,
                                                                a: alpha)
                    editBufferWeightsRegular.add(vertex: vertex)
                    editBufferWeightsPrecise.add(vertex: vertex)
                }
            } else {
                for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
                    let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
                    let red = RTJ.jiggleFillLightFrozen.red
                    let green = RTJ.jiggleFillLightFrozen.green
                    let blue = RTJ.jiggleFillLightFrozen.blue
                    let vertex = Shape2DColoredVertex(x: jiggleMeshPoint.transformedX,
                                                                y: jiggleMeshPoint.transformedY,
                                                                r: red,
                                                                g: green,
                                                                b: blue,
                                                                a: alpha)
                    editBufferWeightsRegular.add(vertex: vertex)
                    editBufferWeightsPrecise.add(vertex: vertex)
                }
            }
        } else {
            if isDarkMode {
                for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
                    let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
                    let red = RTJ.getFillRedDark(level: jiggleMeshPoint.level,
                                                         ceiling: ceiling,
                                                         percent: jiggleMeshPoint.percentOuter)
                    let green = RTJ.getFillGreenDark(level: jiggleMeshPoint.level,
                                                             ceiling: ceiling,
                                                             percent: jiggleMeshPoint.percentOuter)
                    let blue = RTJ.getFillBlueDark(level: jiggleMeshPoint.level,
                                                           ceiling: ceiling,
                                                           percent: jiggleMeshPoint.percentOuter)
                    let vertex = Shape2DColoredVertex(x: jiggleMeshPoint.transformedX,
                                                                y: jiggleMeshPoint.transformedY,
                                                                r: red,
                                                                g: green,
                                                                b: blue,
                                                                a: alpha)
                    editBufferWeightsRegular.add(vertex: vertex)
                    editBufferWeightsPrecise.add(vertex: vertex)
                }
            } else {
                for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
                    let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
                    let red = RTJ.getFillRedLight(level: jiggleMeshPoint.level,
                                                          ceiling: ceiling,
                                                          percent: jiggleMeshPoint.percentOuter)
                    let green = RTJ.getFillGreenLight(level: jiggleMeshPoint.level,
                                                              ceiling: ceiling,
                                                              percent: jiggleMeshPoint.percentOuter)
                    let blue = RTJ.getFillBlueLight(level: jiggleMeshPoint.level,
                                                            ceiling: ceiling,
                                                            percent: jiggleMeshPoint.percentOuter)
                    let vertex = Shape2DColoredVertex(x: jiggleMeshPoint.transformedX,
                                                                y: jiggleMeshPoint.transformedY,
                                                                r: red,
                                                                g: green,
                                                                b: blue,
                                                                a: alpha)
                    editBufferWeightsRegular.add(vertex: vertex)
                    editBufferWeightsPrecise.add(vertex: vertex)
                }
            }
        }
    }
    
    func refreshTriangleBuffersViewStandard() {
        
        viewBuffer.reset()
        for indexIndex in 0..<indexCount {
            viewBuffer.add(index: indices[indexIndex])
        }
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
            let vertex = Sprite3DVertex(x: jiggleMeshPoint.animatedX,
                                                  y: jiggleMeshPoint.animatedY,
                                                  z: -jiggleMeshPoint.animatedZ,
                                                  u: jiggleMeshPoint.u,
                                                  v: jiggleMeshPoint.v)
            viewBuffer.add(vertex: vertex)
        }
    }
    
    func refreshTriangleBuffersViewStereoscopic(stereoSpreadBase: Float,
                                                stereoSpreadMax: Float) {
        viewBufferStereoscopic.reset()
        for indexIndex in 0..<indexCount {
            viewBufferStereoscopic.add(index: indices[indexIndex])
        }
        //let shiftMin = jiggleViewController.stereoSpreadBase
        //let shiftRange = jiggleViewController.stereoSpreadMax - shiftMin
        let shiftMin = stereoSpreadBase
        let shiftRange = stereoSpreadMax - shiftMin
        
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
            let shift = shiftMin + jiggleMeshPoint.percent * shiftRange
            let vertexNode = Sprite3DVertexStereoscopic(x: jiggleMeshPoint.animatedX,
                                                                  y: jiggleMeshPoint.animatedY,
                                                                  z: -jiggleMeshPoint.animatedZ,
                                                                  u: jiggleMeshPoint.u,
                                                                  v: jiggleMeshPoint.v,
                                                                  shift: shift)
            viewBufferStereoscopic.add(vertex: vertexNode)
        }
    }
    
    func refreshTriangleBuffersSwivel(isDarkMode: Bool,
                                      sortedGuideCount: Int) {
        
        swivelBuffer.reset()
        swivelBloomBuffer.reset()
        
        for indexIndex in 0..<indexCount {
            swivelBuffer.add(index: indices[indexIndex])
            swivelBloomBuffer.add(index: indices[indexIndex])
        }
        
        let ceiling = (sortedGuideCount + 1)
        
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
            let vertex = Shape3DVertex(x: jiggleMeshPoint.transformedX,
                                                 y: jiggleMeshPoint.transformedY,
                                                 z: jiggleMeshPoint.transformedZ)
            swivelBloomBuffer.add(vertex: vertex)
        }
        
        if isDarkMode {
            for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
                let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
                let red = RTJ.getFillRedDark(level: jiggleMeshPoint.level,
                                                     ceiling: ceiling,
                                                     percent: jiggleMeshPoint.percentOuter)
                let green = RTJ.getFillGreenDark(level: jiggleMeshPoint.level,
                                                         ceiling: ceiling,
                                                         percent: jiggleMeshPoint.percentOuter)
                let blue = RTJ.getFillBlueDark(level: jiggleMeshPoint.level,
                                                       ceiling: ceiling,
                                                       percent: jiggleMeshPoint.percentOuter)
                let vertex = Sprite3DLightedColoredVertex(x: jiggleMeshPoint.transformedX,
                                                          y: jiggleMeshPoint.transformedY,
                                                          z: jiggleMeshPoint.transformedZ,
                                                          u: jiggleMeshPoint.u,
                                                          v: jiggleMeshPoint.v,
                                                          normalX: jiggleMeshPoint.normalX,
                                                          normalY: jiggleMeshPoint.normalY,
                                                          normalZ: jiggleMeshPoint.normalZ,
                                                          r: red,
                                                          g: green,
                                                          b: blue,
                                                          a: 1.0)
                swivelBuffer.add(vertex: vertex)
            }
        } else {
            for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
                let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
                let red = RTJ.getFillRedLight(level: jiggleMeshPoint.level,
                                                      ceiling: ceiling,
                                                      percent: jiggleMeshPoint.percentOuter)
                let green = RTJ.getFillGreenLight(level: jiggleMeshPoint.level,
                                                          ceiling: ceiling,
                                                          percent: jiggleMeshPoint.percentOuter)
                let blue = RTJ.getFillBlueLight(level: jiggleMeshPoint.level,
                                                        ceiling: ceiling,
                                                        percent: jiggleMeshPoint.percentOuter)
                let vertex = Sprite3DLightedColoredVertex(x: jiggleMeshPoint.transformedX,
                                                                    y: jiggleMeshPoint.transformedY,
                                                                    z: jiggleMeshPoint.transformedZ,
                                                                    u: jiggleMeshPoint.u,
                                                                    v: jiggleMeshPoint.v,
                                                                    normalX: Float.random(in: -1.0...1.0),
                                                                    normalY: Float.random(in: -1.0...1.0),
                                                                    normalZ: Float.random(in: -1.0...1.0),
                                                                    r: red,
                                                                    g: green,
                                                                    b: blue,
                                                                    a: 1.0)
                swivelBuffer.add(vertex: vertex)
            }
        }
    }
}
