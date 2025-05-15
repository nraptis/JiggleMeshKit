//
//  PolyMesh.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 11/15/23.
//
//  Verified on 11/9/2024 by Nick Raptis
//

import Foundation
import MathKit
import TriangleKit

public class PolyMesh {
    
    public let triangleData = PolyMeshTriangleData()
    
    var isFast = false
    
    var edgeRingPoints = [RingPoint]()
    var edgeRingPointCount = 0
    public func addEdgeRingPoint(_ edgeRingPoint: RingPoint) {
        while edgeRingPoints.count <= edgeRingPointCount {
            edgeRingPoints.append(edgeRingPoint)
        }
        edgeRingPoints[edgeRingPointCount] = edgeRingPoint
        edgeRingPointCount += 1
    }
    
    public func purgeEdgeRingPoints() {
        for edgeRingPointIndex in 0..<edgeRingPointCount {
            PolyMeshPartsFactory.shared.depositRingPoint(edgeRingPoints[edgeRingPointIndex])
        }
        edgeRingPointCount = 0
    }
    
    
    public let ring: Ring
    public init() {
        self.ring = PolyMeshPartsFactory.shared.withdrawRing(triangleData: triangleData)
    }
    
    func reset() {
        triangleData.reset()
        purgeEdgeRingPoints()
        PolyMeshPartsFactory.shared.depositRingContent(ring)
    }
    
    public func addPointsBegin() {
        reset()
        ring.addPointsBegin(depth: 0)
    }
    
    public func addPoint(x: Float,
                  y: Float,
                  controlIndex: Int) {
        ring.addPoint(x: x,
                      y: y,
                      controlIndex: controlIndex)
    }
    
    public func addPointsCommit(jiggleMesh: JiggleMesh,
                         isFast: Bool,
                         ignoreDuplicates: Bool) {
        
        self.isFast = false
        ring.isBroken = false
        
        if !ignoreDuplicates {
            var fixOuterRing = true
            while fixOuterRing {
                fixOuterRing = false
                if ring.ringPointCount >= 3 {
                    if ring.containsDuplicatePointsOuter() {
                        ring.resolveOneDuplicatePointOuter()
                        fixOuterRing = true
                    }
                }
            }
        }
        
        if ring.isCounterClockwiseRingPoints() {
            ring.resolveCounterClockwiseRingPoints()
        }
        
        if !ring.attemptToBeginBuildAndCheckIfBroken(needsPointInsidePolygonBucket: true,
                                                     needsLineSegmentBucket: true,
                                                     ignoreDuplicates: ignoreDuplicates) {
            return
        }
        
        for ringPointIndex in 0..<ring.ringPointCount {
            let ringPoint = ring.ringPoints[ringPointIndex]
            
            let edgeRingPoint = PolyMeshPartsFactory.shared.withdrawRingPoint()
            edgeRingPoint.x = ringPoint.x
            edgeRingPoint.y = ringPoint.y
            addEdgeRingPoint(edgeRingPoint)
        }
        
        jiggleMesh.handleShapeUpdate(ringLineSegments: ring.ringLineSegments,
                                          ringLineSegmentCount: ring.ringLineSegmentCount,
                                          ringPoints: ring.ringPoints,
                                          ringPointCount: ring.ringPointCount)
        
        if isFast {
            ring.meshifyWithFastAlgorithm()
            self.isFast = true
        } else {
            ring.meshifyRecursively(needsSafetyCheckA: false, needsSafetyCheckB: false)
            
            for edgeRingPointIndex in 0..<edgeRingPointCount {
                let edgeRingPoint = edgeRingPoints[edgeRingPointIndex]
                triangleData.markEdge(x: edgeRingPoint.x,
                                      y: edgeRingPoint.y)
            }
            
            self.isFast = false
        }
    }

    func addIndexTriangle(p1: Math.Point,
                          p2: Math.Point,
                          p3: Math.Point) {
        addIndexTriangle(x1: p1.x, y1: p1.y,
                         x2: p2.x, y2: p2.y,
                         x3: p3.x, y3: p3.y)
    }
    
    func addIndexTriangle(x1: Float, y1: Float,
                          x2: Float, y2: Float,
                          x3: Float, y3: Float) {
        triangleData.add(x1: x1, y1: y1,
                         x2: x2, y2: y2,
                         x3: x3, y3: y3)
    }
}
