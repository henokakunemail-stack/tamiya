xlua.hotfix(CS.HotfixCalc, 'Add', function(self, a, b)
    return a + b
end)

xlua.hotfix(CS.HotfixCalc, 'TestOut', function(self, a, c, go)
    print('TestOut', self, a, c, go)
    if go then error('test error') end
    return a + 10, a + 20, 'right version'
end)

xlua.hotfix(CS.LuaHelper, 'ContinueToBattle2', function(self)
    print('ContinueToBattle2')
end)


xlua.hotfix(CS.HotfixCalc, {
    Test1 = function(self)
        print('Test1', self)
        return 1
    end;
    Test2 = function(self, a, b)
        print('Test1', self, a, b)
        return a + 10, 1024, b
    end;
    Test3 = function(a)
        print(a)
        return 10
    end;
    Test4 = function(a)
        print(a)
    end;
    Test5 = function(self, a, ...)
        print('Test4', self, a, ...)
    end
})



