#vector_partitions
@test collect(vector_partitions([1,1])) ==  Any[[[1,0],[0,1]],[[1,1]]]
@test collect(vector_partitions([2,1])) ==  Any[[[1, 0], [1, 0], [0, 1]],
                                                [[2, 0], [0, 1]],
                                                [[1, 1], [1, 0]],
                                                [[2, 1]]]
@test collect(vector_partitions([2,1],[0,2])) ==  Any[[[1,1],[1,0]],[[2,1]]]
@test collect(vector_partitions([2,1],[3,2])) == []

@test_throws DomainError vector_partitions([-3,2])
@test_throws DomainError vector_partitions([3,2],[-2,-3])

@test length(vector_partitions([1,1],[2,3])) == 0
@test length(vector_partitions([0,0,0])) == 0

