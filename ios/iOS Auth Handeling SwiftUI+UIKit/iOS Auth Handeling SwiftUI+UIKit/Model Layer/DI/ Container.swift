// Created by Anton Kukhlevskyi on 2025-01-09.
// Copyright © 2025 Airbnb Inc. All rights reserved.

import Swinject

extension Container {
  class Builder {
    private var assemblies: [Assembly] = []
  
    func register(_ assembly: Assembly) -> Builder {
      assemblies.append(assembly)
      return self
    }

    func build() -> Assembler {
      return Assembler(assemblies)
    }
  }

  static func builder() -> Container.Builder {
    return Container.Builder()
  }
}


//extension Resolver {
//  func resolve<Service>(name: String? = nil) -> Service? {
//    return if let name {
//      resolve<Service>(Service.self, name: name)
//    } else {
//      resolve<Service>(Service.self)
//    }
//  }
//
//  func resolve<Service, Arg1>(
//    name: String? = nil,
//    argument: Arg1
//  ) -> Service? {
//    return if let name {
//      resolve<Service>(Service.self, name: name, argument: argument)
//    } else {
//      resolve<Service>(Service.self, argument: argument)
//    }
//  }
//
//  func resolve<Service, Arg1, Arg2>(
//    name: String? = nil,
//    arguments arg1: Arg1, _ arg2: Arg2
//  ) -> Service? {
//    return if let name {
//      resolve<Service>(Service.self, name: name, arguments: arg1, arg2)
//    } else {
//      resolve<Service>(Service.self, arguments: arg1, arg2)
//    }
//  }
//
//  func resolve<Service, Arg1, Arg2, Arg3>(
//    name: String? = nil,
//    arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3
//  ) -> Service? {
//    return if let name {
//      resolve<Service>(Service.self, name: name, arguments: arg1, arg2, arg3)
//    } else {
//      resolve<Service>(Service.self, arguments: arg1, arg2, arg3)
//    }
//  }
//
//  func resolve<Service, Arg1, Arg2, Arg3, Arg4>(
//    name: String? = nil,
//    arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4
//  ) -> Service? {
//    return if let name {
//      resolve<Service>(Service.self, name: name, arguments: arg1, arg2, arg3, arg4)
//    } else {
//      resolve<Service>(Service.self, arguments: arg1, arg2, arg3, arg4)
//    }
//  }
//
//  func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5>(
//    name: String? = nil,
//    arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5
//  ) -> Service? {
//    return if let name {
//      resolve<Service>(Service.self, name: name, arguments: arg1, arg2, arg3, arg4, arg5)
//    } else {
//      resolve<Service>(Service.self, arguments: arg1, arg2, arg3, arg4, arg5)
//    }
//  }
//
//  func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6>(
//    name: String? = nil,
//    arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6
//  ) -> Service? {
//    return if let name {
//      resolve<Service>(Service.self, name: name, arguments: arg1, arg2, arg3, arg4, arg5, arg6)
//    } else {
//      resolve<Service>(Service.self, arguments: arg1, arg2, arg3, arg4, arg5, arg6)
//    }
//  }
//
//  func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7>(
//    name: String? = nil,
//    arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7
//  ) -> Service? {
//    return if let name {
//      resolve<Service>(Service.self, name: name, arguments: arg1, arg2, arg3, arg4, arg5, arg6, arg7)
//    } else {
//      resolve<Service>(Service.self, arguments: arg1, arg2, arg3, arg4, arg5, arg6, arg7)
//    }
//  }
//
//  func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8>(
//    name: String? = nil,
//    arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8
//  ) -> Service? {
//    return if let name {
//      resolve<Service>(Service.self, name: name, arguments: arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
//    } else {
//      resolve<Service>(Service.self, arguments: arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
//    }
//  }
//
//  func resolve<Service, Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7, Arg8, Arg9>(
//    name: String? = nil,
//    arguments arg1: Arg1, _ arg2: Arg2, _ arg3: Arg3, _ arg4: Arg4, _ arg5: Arg5, _ arg6: Arg6, _ arg7: Arg7, _ arg8: Arg8, _ arg9: Arg9
//  ) -> Service? {
//    return if let name {
//      resolve<Service>(Service.self, name: name, arguments: arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
//    } else {
//      resolve<Service>(Service.self, arguments: arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
//    }
//  }
//}
