//
//  JiggleMesh.swift
//  Yo Mamma Be Ugly
//
//  Created by Nick Raptis on 2/17/24.
//

import Foundation
import MathKit
import TriangleKit
import RenderKit
import Metal
import WeightCurveKit
import GuideKit

public protocol BignessOwningConforming {
    var bigness: Float { get }
}

public class JiggleMesh {
    
    public var editBufferStandardRegular = IndexedShapeBuffer2DColored()
    public var editBufferWeightsRegular = IndexedShapeBuffer2DColored()
    public var editBufferStandardPrecise = IndexedShapeBuffer2DColored()
    public var editBufferWeightsPrecise = IndexedShapeBuffer2DColored()
    public let swivelBuffer = IndexedSpriteBuffer<Sprite3DLightedColoredVertex,
                                                  UniformsLightsVertex,
                                                  UniformsPhongFragment>()
    public let swivelBloomBuffer = IndexedShapeBuffer3D()
    public var viewBuffer = IndexedSpriteBuffer3D()
    public var viewBufferStereoscopic = IndexedSpriteBuffer3DStereoscopic()
    
    public init() {
        
    }
    
    public private(set) var indices = [UInt32]()
    public private(set) var indexCount = 0
    
    var heightMaximum = Float(256.0)
    
    public static let heightFactorPhonePortrait = Float(0.80)
    public static let heightFactorPhoneLandscape = Float(0.65)
    public static let heightFactorPad = Float(0.85)
    
    public var jiggleMeshPoints = [JiggleMeshPoint]()
    public var jiggleMeshPointCount = 0
    public func addJiggleMeshPoint(_ jiggleMeshPoint: JiggleMeshPoint) {
        while jiggleMeshPoints.count <= jiggleMeshPointCount {
            jiggleMeshPoints.append(jiggleMeshPoint)
        }
        jiggleMeshPoints[jiggleMeshPointCount] = jiggleMeshPoint
        jiggleMeshPointCount += 1
    }
    public func purgeJiggleMeshPoints() {
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            JiggleMeshPartsFactory.shared.depositJiggleMeshPoint(jiggleMeshPoints[jiggleMeshPointIndex])
        }
        jiggleMeshPointCount = 0
    }
    
    public var cameraCalibrationPoints = [JiggleMeshPoint]()
    public var cameraCalibrationPointCount = 0
    public func addCameraCalibrationPoint(_ cameraCalibrationPoint: JiggleMeshPoint) {
        while cameraCalibrationPoints.count <= cameraCalibrationPointCount {
            cameraCalibrationPoints.append(cameraCalibrationPoint)
        }
        cameraCalibrationPoints[cameraCalibrationPointCount] = cameraCalibrationPoint
        cameraCalibrationPointCount += 1
    }
    func purgeCameraCalibrationPoints() {
        for cameraCalibrationPointIndex in 0..<cameraCalibrationPointCount {
            JiggleMeshPartsFactory.shared.depositJiggleMeshPoint(cameraCalibrationPoints[cameraCalibrationPointIndex])
        }
        cameraCalibrationPointCount = 0
    }
    
    let guideWeightSegmentBucket = GuideWeightSegmentBucket()
    var guideWeightSegments = [GuideWeightSegment]()
    var guideWeightSegmentCount = 0
    func addGuideWeightSegment(_ guideWeightSegment: GuideWeightSegment) {
        while guideWeightSegments.count <= guideWeightSegmentCount {
            guideWeightSegments.append(guideWeightSegment)
        }
        guideWeightSegments[guideWeightSegmentCount] = guideWeightSegment
        guideWeightSegmentCount += 1
    }
    
    func purgeGuideWeightSegments() {
        for guideWeightSegmentsIndex in 0..<guideWeightSegmentCount {
            GuidePartsFactory.shared.depositGuideWeightSegment(guideWeightSegments[guideWeightSegmentsIndex])
        }
        guideWeightSegmentCount = 0
    }
    
    public var guideWeightPoints = [GuideWeightPoint]()
    public var guideWeightPointCount = 0
    func addGuideWeightPoint(_ guideWeightPoint: GuideWeightPoint) {
        while guideWeightPoints.count <= guideWeightPointCount {
            guideWeightPoints.append(guideWeightPoint)
        }
        guideWeightPoints[guideWeightPointCount] = guideWeightPoint
        guideWeightPointCount += 1
    }
    
    func purgeGuideWeightPoints() {
        for guideWeightPointIndex in 0..<guideWeightPointCount {
            GuidePartsFactory.shared.depositGuideWeightPoint(guideWeightPoints[guideWeightPointIndex])
        }
        guideWeightPointCount = 0
    }
    
    var examineJiggleMeshPoints = [JiggleMeshPoint]()
    var examineJiggleMeshPointCount = 0
    func addExaineJiggleMeshPoint(_ examineJiggleMeshPoint: JiggleMeshPoint) {
        while examineJiggleMeshPoints.count <= examineJiggleMeshPointCount {
            examineJiggleMeshPoints.append(examineJiggleMeshPoint)
        }
        examineJiggleMeshPoints[examineJiggleMeshPointCount] = examineJiggleMeshPoint
        examineJiggleMeshPointCount += 1
    }
    func resetExaineJiggleMeshPoints() {
        examineJiggleMeshPointCount = 0
    }
    
    func calculateExaminePoints() {
        resetExaineJiggleMeshPoints()
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
            addExaineJiggleMeshPoint(jiggleMeshPoint)
        }
    }
    
    func calculateExaminePoints(level: Int) {
        resetExaineJiggleMeshPoints()
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
            if jiggleMeshPoint.level == level {
                addExaineJiggleMeshPoint(jiggleMeshPoint)
            }
        }
    }
    
    public func handleShapeUpdate(ringLineSegments: [RingLineSegment],
                                  ringLineSegmentCount: Int,
                                  ringPoints: [RingPoint],
                                  ringPointCount: Int) {
        purgeGuideWeightSegments()
        for ringLineSegmentIndex in 0..<ringLineSegmentCount {
            let ringLineSegment = ringLineSegments[ringLineSegmentIndex]
            let guideWeightSegment = GuidePartsFactory.shared.withdrawGuideWeightSegment()
            guideWeightSegment.readFrom(ringLineSegment)
            addGuideWeightSegment(guideWeightSegment)
        }
        
        purgeGuideWeightPoints()
        for ringPointIndex in 0..<ringPointCount {
            let ringPoint = ringPoints[ringPointIndex]
            let guideWeightPoint = GuidePartsFactory.shared.withdrawGuideWeightPoint()
            guideWeightPoint.x = ringPoint.x
            guideWeightPoint.y = ringPoint.y
            guideWeightPoint.controlIndex = ringPoint.controlIndex
            addGuideWeightPoint(guideWeightPoint)
        }
    }
    
    func distanceFromEdge(x: Float, y: Float) -> Float {
        var bestDistanceSquared = Float(100_000_000.0)
        for guideWeightSegmentsIndex in 0..<guideWeightSegmentCount {
            let guideWeightSegment = guideWeightSegments[guideWeightSegmentsIndex]
            let distanceSquared = guideWeightSegment.distanceSquaredToClosestPoint(x, y)
            if distanceSquared < bestDistanceSquared {
                bestDistanceSquared = distanceSquared
            }
        }
        if bestDistanceSquared > Math.epsilon {
            return sqrtf(bestDistanceSquared)
        } else {
            return 0.0
        }
    }
    
    var widthNaturalized = Float(1024.0)
    var heightNaturalized = Float(1024.0)
    
    public func load(graphics: Graphics,
                     backgroundSprite: Sprite,
                     widthNaturalized: Float,
                     heightNaturalized: Float) {
        self.widthNaturalized = widthNaturalized
        self.heightNaturalized = heightNaturalized
        
        editBufferStandardRegular.load_t_n(graphics: graphics)
        editBufferWeightsRegular.load_t_n(graphics: graphics)
        
        editBufferStandardPrecise.load_t_n(graphics: graphics)
        editBufferWeightsPrecise.load_t_n(graphics: graphics)
        
        swivelBuffer.load(graphics: graphics, sprite: backgroundSprite)
        swivelBuffer.primitiveType = .triangle
        swivelBuffer.cullMode = .none
        
        swivelBloomBuffer.load(graphics: graphics)
        swivelBloomBuffer.primitiveType = .triangle
        swivelBloomBuffer.cullMode = .none
        
        viewBuffer.load(graphics: graphics, sprite: backgroundSprite)
        viewBuffer.primitiveType = .triangle
        viewBuffer.cullMode = .none
        
        viewBufferStereoscopic.load(graphics: graphics, sprite: backgroundSprite)
        viewBufferStereoscopic.primitiveType = .triangle
        viewBufferStereoscopic.cullMode = .none
    }
    
    public func updateActive(amountX: Float,
                             amountY: Float,
                             guideCenterX: Float,
                             guideCenterY: Float,
                             jiggleCenterX: Float,
                             jiggleCenterY: Float,
                             rotationFactor: Float,
                             scaleFactor: Float) {
        
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            jiggleMeshPoints[jiggleMeshPointIndex].updateActive(amountX: amountX,
                                                                amountY: amountY,
                                                                guideCenterX: guideCenterX,
                                                                guideCenterY: guideCenterY,
                                                                jiggleCenterX: jiggleCenterX,
                                                                jiggleCenterY: jiggleCenterY,
                                                                rotationFactor: rotationFactor,
                                                                scaleFactor: scaleFactor)
        }
    }
    
    public func updateInactive() {
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            jiggleMeshPoints[jiggleMeshPointIndex].updateInactive()
        }
    }
    
    public var meshMinX = Float(0.0)
    public var meshMaxX = Float(0.0)
    public var meshMinY = Float(0.0)
    public var meshMaxY = Float(0.0)
    public func refreshMeshStandard(triangleData: PolyMeshTriangleData,
                                    jiggleCenter: Math.Point,
                                    jiggleScale: Float,
                                    jiggleRotation: Float) {
        refreshMesh(triangleData: triangleData,
                    jiggleCenter: jiggleCenter,
                    jiggleScale: jiggleScale,
                    jiggleRotation: jiggleRotation)
        refreshUpdateAllInactive()
    }
    
    public func refreshMeshWeights(triangleData: PolyMeshTriangleData,
                                   jiggleCenter: Math.Point,
                                   jiggleScale: Float,
                                   jiggleRotation: Float,
                                   weightCurveMapperNodes: [WeightCurveMapperNode],
                                   weightCurveMapperNodeCount: Int,
                                   sortedGuides: [Guide],
                                   sortedGuideCount: Int,
                                   landscape: Bool,
                                   scale: Float,
                                   isIpad: Bool,
                                   guideCenterX: Float,
                                   guideCenterY: Float) {
        
        refreshMesh(triangleData: triangleData,
                    jiggleCenter: jiggleCenter,
                    jiggleScale: jiggleScale,
                    jiggleRotation: jiggleRotation)
        calculateMeshPointLevels(sortedGuides: sortedGuides,
                                 sortedGuideCount: sortedGuideCount)
        calculateMeshPointOuterDistances(sortedGuides: sortedGuides,
                                         sortedGuideCount: sortedGuideCount,
                                         landscape: landscape,
                                         scale: scale,
                                         isPad: isIpad,
                                         guideCenterX: guideCenterX,
                                         guideCenterY: guideCenterY)
        calculateHeights(weightCurveMapperNodes: weightCurveMapperNodes,
                         weightCurveMapperNodeCount: weightCurveMapperNodeCount)
        calculateMovePercents()
        calculateZ()
        calculateCameraCalibrationPoints()
        refreshUpdateAllInactive()
    }
    
    private func calculateCameraCalibrationPoints() {
        
        let spanX = (meshMaxX - meshMinX)
        let spanY = (meshMaxY - meshMinY)
        
        let radius = max(spanX, spanY) * 0.5
        
        for i in 0..<12 {
            
            let percent = Float(i) / Float(12.0)
            
            let dirX = sinf(percent * Math.pi2)
            let dirY = -cosf(percent * Math.pi2)
            
            addCameraCalibrationPoint(x: dirX * radius,
                                      y: dirY * radius,
                                      z: 0.0)
        }
        
        let height33 = sinf(0.333333 * Math.pi_2) * heightMaximum
        let radius66 = radius * 0.666667
        for i in 0..<8 {
            
            let percent = Float(i) / Float(8.0)
            
            let dirX = sinf(percent * Math.pi2)
            let dirY = -cosf(percent * Math.pi2)
            
            addCameraCalibrationPoint(x: dirX * radius66,
                                      y: dirY * radius66,
                                      z: -height33)
        }
        
        let height66 = sinf(0.666667 * Math.pi_2) * heightMaximum
        let radius33 = radius * 0.333333
        for i in 0..<4 {
            
            let percent = Float(i) / Float(4.0)
            
            let dirX = sinf(percent * Math.pi2)
            let dirY = -cosf(percent * Math.pi2)
            
            addCameraCalibrationPoint(x: dirX * radius33,
                                      y: dirY * radius33,
                                      z: -height66)
        }
        
        addCameraCalibrationPoint(x: 0.0,
                                  y: 0.0,
                                  z: -heightMaximum)
    }
    
    private func addCameraCalibrationPoint(x: Float, y: Float, z: Float) {
        let meshPoint = JiggleMeshPartsFactory.shared.withdrawJiggleMeshPoint()
        meshPoint.baseX = x
        meshPoint.baseY = y
        meshPoint.baseZ = z
        meshPoint.transformedX = x
        meshPoint.transformedY = y
        meshPoint.transformedZ = z
        addCameraCalibrationPoint(meshPoint)
    }
    
    private func refreshMesh(triangleData: PolyMeshTriangleData,
                             jiggleCenter: Math.Point,
                             jiggleScale: Float,
                             jiggleRotation: Float) {
        
        let maximumIndexCount = triangleData.triangleCount * 3
        
        while indices.count < maximumIndexCount {
            indices.append(0)
        }
        
        indexCount = 0
        for triangleIndex in 0..<triangleData.triangleCount {
            let triangle = triangleData.triangles[triangleIndex]
            
            indices[indexCount] = triangle.index1
            indexCount += 1
            
            indices[indexCount] = triangle.index2
            indexCount += 1
            
            indices[indexCount] = triangle.index3
            indexCount += 1
        }
        
        purgeJiggleMeshPoints()
        
        for vertexIndex in 0..<triangleData.vertexCount {
            let dataVertex = triangleData.vertices[vertexIndex]
            let jiggleMeshPoint = JiggleMeshPartsFactory.shared.withdrawJiggleMeshPoint()
            jiggleMeshPoint.baseX = dataVertex.x
            jiggleMeshPoint.baseY = dataVertex.y
            jiggleMeshPoint.isEdge = dataVertex.isEdge
            addJiggleMeshPoint(jiggleMeshPoint)
        }
        
        refreshTransform(jiggleCenter: jiggleCenter, jiggleScale: jiggleScale, jiggleRotation: jiggleRotation)
    }
    
    public func refreshMeshWeightsOnly(weightCurveMapperNodes: [WeightCurveMapperNode],
                                weightCurveMapperNodeCount: Int) {
        calculateHeights(weightCurveMapperNodes: weightCurveMapperNodes,
                         weightCurveMapperNodeCount: weightCurveMapperNodeCount)
        calculateMovePercents()
        calculateZ()
        refreshUpdateAllInactive()
    }
    
    public func refreshMeshAffine(jiggleCenter: Math.Point, jiggleScale: Float, jiggleRotation: Float) {
        refreshTransform(jiggleCenter: jiggleCenter, jiggleScale: jiggleScale, jiggleRotation: jiggleRotation)
        refreshUpdateAllInactive()
    }
    
    private func refreshUpdateAllInactive() {
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
            jiggleMeshPoint.updateInactive()
        }
    }
    
    private func getU(_ x: Float) -> Float {
        return x / widthNaturalized
    }
    
    private func getV(_ y: Float) -> Float {
        return y / heightNaturalized
    }
    
    private func refreshTransform(jiggleCenter: Math.Point,
                                  jiggleScale: Float,
                                  jiggleRotation: Float) {
        
        if jiggleMeshPointCount > 0 {
            meshMinX = Float(100_000_000.0)
            meshMaxX = Float(-100_000_000.0)
            meshMinY = Float(100_000_000.0)
            meshMaxY = Float(-100_000_000.0)
        } else {
            meshMinX = Float(0.0)
            meshMaxX = Float(0.0)
            meshMinY = Float(0.0)
            meshMaxY = Float(0.0)
        }
        
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
            var point = Math.Point(x: jiggleMeshPoint.baseX, y: jiggleMeshPoint.baseY)
            point = Math.transformPoint(point: point, translation: jiggleCenter, scale: jiggleScale, rotation: jiggleRotation)
            
            jiggleMeshPoint.transformedX = point.x
            jiggleMeshPoint.transformedY = point.y
            jiggleMeshPoint.u = getU(point.x)
            jiggleMeshPoint.v = getV(point.y)
            
            meshMinX = min(meshMinX, point.x)
            meshMaxX = max(meshMaxX, point.x)
            meshMinY = min(meshMinY, point.y)
            meshMaxY = max(meshMaxY, point.y)
        }
    }
    
    private func calculateHeights(weightCurveMapperNodes: [WeightCurveMapperNode],
                                  weightCurveMapperNodeCount: Int) {
        
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
            let level = jiggleMeshPoint.level
            
            if level >= 0 && level < weightCurveMapperNodeCount {
                let weightCurveMapperNode = weightCurveMapperNodes[level]
                let measuredY = weightCurveMapperNode.getY(x: jiggleMeshPoint.percentOuter)
                jiggleMeshPoint.height = measuredY * heightMaximum
            }
        }
    }
    
    private func calculateMovePercents() {
        if heightMaximum > Math.epsilon {
            for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
                let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
                jiggleMeshPoint.percent = (heightMaximum - jiggleMeshPoint.height) / heightMaximum
            }
        } else {
            for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
                let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
                jiggleMeshPoint.percent = 0.0
            }
        }
    }
    
    private func calculateZ() {
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
            
            jiggleMeshPoint.baseZ = jiggleMeshPoint.height - heightMaximum
            jiggleMeshPoint.transformedZ = jiggleMeshPoint.height - heightMaximum
            jiggleMeshPoint.animatedZ = jiggleMeshPoint.height - heightMaximum
        }
    }
    
    private func calculateMeshPointLevels(sortedGuides: [Guide],
                                          sortedGuideCount: Int) {
        for jiggleMeshPointIndex in 0..<jiggleMeshPointCount {
            let jiggleMeshPoint = jiggleMeshPoints[jiggleMeshPointIndex]
            jiggleMeshPoint.level = 0
            
            var guideIndex = sortedGuideCount - 1
            while guideIndex >= 0 {
                let guide = sortedGuides[guideIndex]
                if guide.guideWeightPointInsidePolygonBucket.query(x: jiggleMeshPoint.baseX,
                                                                   y: jiggleMeshPoint.baseY) {
                    jiggleMeshPoint.level = guideIndex + 1
                    break
                }
                guideIndex -= 1
            }
        }
    }
    
    private func calculateMeshPointOuterDistances(sortedGuides: [Guide],
                                                  sortedGuideCount: Int,
                                                  landscape: Bool,
                                                  scale: Float,
                                                  isPad: Bool,
                                                  guideCenterX: Float,
                                                  guideCenterY: Float) {
        
        calculateExaminePoints()
        calculateExaminePointsDistances(guideWeightSegmentBucket: guideWeightSegmentBucket,
                                        guideWeightSegments: guideWeightSegments, 
                                        guideWeightSegmentCount: guideWeightSegmentCount)
        setExaminePointDistancesToOuter()
        
        var largestDistance = Float(32.0)
        for examineJiggleMeshPointIndex in 0..<examineJiggleMeshPointCount {
            let examineJiggleMeshPoint = examineJiggleMeshPoints[examineJiggleMeshPointIndex]
            if examineJiggleMeshPoint.distance > largestDistance {
                largestDistance = examineJiggleMeshPoint.distance
            }
        }
        
        if isPad {
            heightMaximum = largestDistance * Self.heightFactorPad * scale
        } else {
            if landscape {
                heightMaximum = largestDistance * Self.heightFactorPhoneLandscape * scale
            } else {
                heightMaximum = largestDistance * Self.heightFactorPhonePortrait * scale
            }
        }
        
        var previousGuideWeightSegmentBucket = guideWeightSegmentBucket
        var previousGuideWeightSegments = guideWeightSegments
        var previousGuideWeightSegmentCount = guideWeightSegmentCount
        
        for guideIndex in 0..<sortedGuideCount {
            
            let guide = sortedGuides[guideIndex]
            
            calculateExaminePoints(level: guideIndex)
            
            let currentGuideWeightSegmentBucket = guide.guideWeightSegmentBucket
            let currentGuideWeightSegments = guide.guideWeightSegments
            let currentGuideWeightSegmentCount = guide.guideWeightSegmentCount
            
            if guideIndex != 0 {
                calculateExaminePointsDistances(guideWeightSegmentBucket: previousGuideWeightSegmentBucket,
                                                guideWeightSegments: previousGuideWeightSegments,
                                                guideWeightSegmentCount: previousGuideWeightSegmentCount)
                setExaminePointDistancesToOuter()
            }
            
            calculateExaminePointsDistances(guideWeightSegmentBucket: currentGuideWeightSegmentBucket,
                                            guideWeightSegments: currentGuideWeightSegments,
                                            guideWeightSegmentCount: currentGuideWeightSegmentCount)
            setExaminePointDistancesToInner()
            
            calculateExaminePointInnerOuterPercents()
            
            previousGuideWeightSegmentBucket = currentGuideWeightSegmentBucket
            previousGuideWeightSegments = currentGuideWeightSegments
            previousGuideWeightSegmentCount = currentGuideWeightSegmentCount
        }
        
        calculateExaminePoints(level: sortedGuideCount)
        calculateExaminePointsDistances(guideWeightSegmentBucket: previousGuideWeightSegmentBucket,
                                        guideWeightSegments: previousGuideWeightSegments,
                                        guideWeightSegmentCount: previousGuideWeightSegmentCount)
        setExaminePointDistancesToOuter()
        
        calculateExaminePointsDistancesToWeightCenter(guideCenterX: guideCenterX,
                                                      guideCenterY: guideCenterY)
        setExaminePointDistancesToInner()
        calculateExaminePointInnerOuterPercents()
    }
    
    func setExaminePointDistancesToInner() {
        for examineJiggleMeshPointIndex in 0..<examineJiggleMeshPointCount {
            let examineJiggleMeshPoint = examineJiggleMeshPoints[examineJiggleMeshPointIndex]
            examineJiggleMeshPoint.distanceInner = examineJiggleMeshPoint.distance
        }
    }
    
    func setExaminePointDistancesToOuter() {
        for examineJiggleMeshPointIndex in 0..<examineJiggleMeshPointCount {
            let examineJiggleMeshPoint = examineJiggleMeshPoints[examineJiggleMeshPointIndex]
            examineJiggleMeshPoint.distanceOuter = examineJiggleMeshPoint.distance
        }
    }
    
    func calculateExaminePointInnerOuterPercents() {
        for examineJiggleMeshPointIndex in 0..<examineJiggleMeshPointCount {
            let examineJiggleMeshPoint = examineJiggleMeshPoints[examineJiggleMeshPointIndex]
            
            let totalDistance = examineJiggleMeshPoint.distanceInner + examineJiggleMeshPoint.distanceOuter
            if totalDistance > Math.epsilon {
                examineJiggleMeshPoint.percentInner = examineJiggleMeshPoint.distanceInner / totalDistance
                examineJiggleMeshPoint.percentOuter = (1.0 - examineJiggleMeshPoint.percentInner)
            } else {
                examineJiggleMeshPoint.percentInner = 0.0
                examineJiggleMeshPoint.percentOuter = 1.0
            }
        }
    }
    
    func calculateExaminePointsDistancesToWeightCenter(guideCenterX: Float,
                                                       guideCenterY: Float) {
        if examineJiggleMeshPointCount <= 0 {
            return
        }
        for examineJiggleMeshPointIndex in 0..<examineJiggleMeshPointCount {
            let examineJiggleMeshPoint = examineJiggleMeshPoints[examineJiggleMeshPointIndex]
            
            let diffX = examineJiggleMeshPoint.baseX - guideCenterX
            let diffY = examineJiggleMeshPoint.baseY - guideCenterY
            let distanceSquared = diffX * diffX + diffY * diffY
            if distanceSquared > Math.epsilon {
                examineJiggleMeshPoint.distance = sqrtf(distanceSquared)
            } else {
                examineJiggleMeshPoint.distance = 0.0
            }
        }
    }
    
    private func calculateExaminePointsDistances(guideWeightSegmentBucket: GuideWeightSegmentBucket,
                                                 guideWeightSegments: [GuideWeightSegment],
                                                 guideWeightSegmentCount: Int) {
        
        if guideWeightSegmentCount <= 0 {
            return
        }
        
        if examineJiggleMeshPointCount <= 0 {
            return
        }
        
        for examineJiggleMeshPointIndex in 0..<examineJiggleMeshPointCount {
            let examineJiggleMeshPoint = examineJiggleMeshPoints[examineJiggleMeshPointIndex]
            var bestDistanceSquared = Float(100_000_000.0)
            guideWeightSegmentBucket.query(minX: examineJiggleMeshPoint.baseX - 32.0,
                                           maxX: examineJiggleMeshPoint.baseX + 32.0,
                                           minY: examineJiggleMeshPoint.baseY - 32.0,
                                           maxY: examineJiggleMeshPoint.baseY + 32.0)
            if guideWeightSegmentBucket.guideWeightSegmentCount > 6 {
                for bucketGuideWeightSegmentsIndex in 0..<guideWeightSegmentBucket.guideWeightSegmentCount {
                    let guideWeightSegment = guideWeightSegmentBucket.guideWeightSegments[bucketGuideWeightSegmentsIndex]
                    let distanceSquared = guideWeightSegment.distanceSquaredToClosestPoint(examineJiggleMeshPoint.baseX,
                                                                                           examineJiggleMeshPoint.baseY)
                    if distanceSquared < bestDistanceSquared {
                        bestDistanceSquared = distanceSquared
                    }
                }
            } else {
                guideWeightSegmentBucket.query(minX: examineJiggleMeshPoint.baseX - 64.0,
                                               maxX: examineJiggleMeshPoint.baseX + 64.0,
                                               minY: examineJiggleMeshPoint.baseY - 64.0,
                                               maxY: examineJiggleMeshPoint.baseY + 64.0)
                
                if guideWeightSegmentBucket.guideWeightSegmentCount > 6 {
                    for bucketGuideWeightSegmentsIndex in 0..<guideWeightSegmentBucket.guideWeightSegmentCount {
                        let guideWeightSegment = guideWeightSegmentBucket.guideWeightSegments[bucketGuideWeightSegmentsIndex]
                        let distanceSquared = guideWeightSegment.distanceSquaredToClosestPoint(examineJiggleMeshPoint.baseX,
                                                                                               examineJiggleMeshPoint.baseY)
                        if distanceSquared < bestDistanceSquared {
                            bestDistanceSquared = distanceSquared
                        }
                    }
                } else {
                    guideWeightSegmentBucket.query(minX: examineJiggleMeshPoint.baseX - 128.0,
                                                   maxX: examineJiggleMeshPoint.baseX + 128.0,
                                                   minY: examineJiggleMeshPoint.baseY - 128.0,
                                                   maxY: examineJiggleMeshPoint.baseY + 128.0)
                    if guideWeightSegmentBucket.guideWeightSegmentCount > 6 {
                        for bucketGuideWeightSegmentsIndex in 0..<guideWeightSegmentBucket.guideWeightSegmentCount {
                            let guideWeightSegment = guideWeightSegmentBucket.guideWeightSegments[bucketGuideWeightSegmentsIndex]
                            let distanceSquared = guideWeightSegment.distanceSquaredToClosestPoint(examineJiggleMeshPoint.baseX,
                                                                                                   examineJiggleMeshPoint.baseY)
                            if distanceSquared < bestDistanceSquared {
                                bestDistanceSquared = distanceSquared
                            }
                        }
                    } else {
                        for guideWeightSegmentsIndex in 0..<guideWeightSegmentCount {
                            let guideWeightSegment = guideWeightSegments[guideWeightSegmentsIndex]
                            let distanceSquared = guideWeightSegment.distanceSquaredToClosestPoint(examineJiggleMeshPoint.baseX,
                                                                                                   examineJiggleMeshPoint.baseY)
                            if distanceSquared < bestDistanceSquared {
                                bestDistanceSquared = distanceSquared
                            }
                        }
                    }
                }
            }
            
            if bestDistanceSquared > Math.epsilon {
                examineJiggleMeshPoint.distance = sqrtf(bestDistanceSquared)
            } else {
                examineJiggleMeshPoint.distance = 0.0
            }
        }
    }
    
    public func purge() {
        purgeJiggleMeshPoints()
        purgeGuideWeightSegments()
    }
}
