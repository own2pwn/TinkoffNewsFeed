//
// Created by Evgeniy on 26.07.17.
// Copyright (c) 2017 Evgeniy. All rights reserved.
//

import Foundation

protocol IStructToEntityMapperAssembler {
    static func assembly() -> IStructToEntityMapper.Type
}
