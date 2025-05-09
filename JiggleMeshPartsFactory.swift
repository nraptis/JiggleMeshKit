//
//  JiggleMeshPartsFactory.swift
//  Jiggle3
//
//  Created by Nicholas Raptis on 5/9/25.
//

import Foundation
import TriangleKit
import MathKit
import RenderKit
import GuideKit

public class JiggleMeshPartsFactory {
    
    public nonisolated(unsafe) static let shared = JiggleMeshPartsFactory()
    
    private init() {
        
    }
    
    public func dispose() {
        jiggleMeshPoints.removeAll(keepingCapacity: false)
        jiggleMeshPointCount = 0
    }
    
    ////////////////
    ///
    ///
    private var jiggleMeshPoints = [JiggleMeshPoint]()
    var jiggleMeshPointCount = 0
    func depositJiggleMeshPoint(_ jiggleMeshPoint: JiggleMeshPoint) {
        
        jiggleMeshPoint.distanceFromEdge = 0.0
        jiggleMeshPoint.level = 0
        
        while jiggleMeshPoints.count <= jiggleMeshPointCount {
            jiggleMeshPoints.append(jiggleMeshPoint)
        }
        jiggleMeshPoints[jiggleMeshPointCount] = jiggleMeshPoint
        jiggleMeshPointCount += 1
    }
    func withdrawJiggleMeshPoint() -> JiggleMeshPoint {
        if jiggleMeshPointCount > 0 {
            jiggleMeshPointCount -= 1
            return jiggleMeshPoints[jiggleMeshPointCount]
        }
        return JiggleMeshPoint()
    }
    ///
    ///
    ////////////////
    

}
