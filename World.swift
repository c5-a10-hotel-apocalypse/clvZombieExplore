let cubePositions: [CubeInfo] = [
            [-1, 0, 1],
            [1, 0, 1],
            [-1, 0, 0],
            [1, 0, 0],
            [-1, 0, -1],
            [1, 0, -1],
            [-1, 0, -2],
            [1, 0, -2],
            [-1, 0, -4],
            [1, 0, -4],
            [0, 0, -4]
        ].map { CubeInfo(position: $0, direction: .none) }

        let baseRightCubes = cubePositions
            .filter { ![1, 0, -1].contains(Int($0.position.z)) }

        // Tahap 1: badan lorong ke kanan
        let bodyCubes: [CubeInfo] = (1...6).flatMap { step in
            baseRightCubes.map { original in
                CubeInfo(
                    position: SIMD3<Float>(
                        x: original.position.x + Float(step),
                        y: original.position.y,
                        z: original.position.z
                    ),
                    direction: .east
                )
            }
        }

        // Tahap 2: penutup di ujung kanan (xMax + 4)
        let maxX = bodyCubes.map { $0.position.x }.max() ?? 0

        let endCubes: [CubeInfo] = bodyCubes
            .map { $0.position.z }
//            .unique() // ⬅️ kita akan bantu definisikan ini
            .flatMap { z in
                [
                    CubeInfo(position: SIMD3<Float>(x: maxX + 2, y: 0, z: z + 1), direction: .east),
                    CubeInfo(position: SIMD3<Float>(x: maxX + 2, y: 0, z: z),     direction: .east),
                    CubeInfo(position: SIMD3<Float>(x: maxX + 2, y: 0, z: z - 1), direction: .east)
                ]
            }

        let rightCubePositions = bodyCubes + endCubes

        
        
        for cube in cubePositions {
            arView.scene.addAnchor(
                createCube(worldPosition: cube.position, colors: .red, direction: cube.direction)
            )
        }