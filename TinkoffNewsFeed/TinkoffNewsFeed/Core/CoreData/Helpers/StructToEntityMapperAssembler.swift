//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

final class StructToEntityMapperAssembler: IStructToEntityMapperAssembler {
    class func assembly() -> IStructToEntityMapper.Type {
        let mapper = StructToEntityMapper.self

        return mapper
    }
}
