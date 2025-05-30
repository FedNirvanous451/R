class MachineException(Exception):
    def __init__(self, message, extra_info=None):
        super().__init__(message)  # Передаем сообщение в базовый класс


class Mealy:
    paths: dict[str, dict[str, tuple[str, str]]] = {
        'K3': {
            'bend': ('K3', 'A2'),  # исходят из 5
            'exit': ('K1', 'A2'),
            'amass': ('K5', 'A2')
        },
        'K5': {
            'share': ('K0', 'A0')
        },
        'K0': {
            'bend': ('K1', 'A0')
        },
        'K1': {
            'share': ('K3', 'A1'),
            'amass': ('K2', 'A0')
        },
        'K2': {
            'bend': ('K4', 'A0'),
            'amass': ('K2', 'A0')
        },
        'K4': dict()
    }
    known_functions = {ii for i in paths.values() for ii in i}

    def __init__(self) -> None:
        self.state = 'K3'
        self.seen: set[str] = set()
        self.current_dict = self.paths[self.state]

    def select(self, key_for) -> str:
        try:
            if key_for not in self.known_functions:
                raise MachineException("MachineException: 'unknown'")
            if key_for not in self.current_dict:
                raise MachineException("MachineException: 'unsupported'")
            next_state, output = self.current_dict[key_for]
            self.state = next_state
            self.current_dict = self.paths[self.state]
            return output
        except MachineException as e:
            return str(e)

    def has_max_out_edges(self) -> bool:
        return self.state in {'K3'}

    def has_path_to(self, target) -> bool:
        visited = set()
        stack = [self.state]
        while stack:
            current = stack.pop()
            if current == target:
                return True
            visited.add(current)
            self._add_unvisited_neighbors(current, visited, stack)
        return False

    def _add_unvisited_neighbors(self, current, visited, stack):
        current_paths = self.paths.get(current, {})
        for next_state, _ in current_paths.values():
            if next_state not in visited:
                stack.append(next_state)


def main():
    return Mealy()


def test_initial_state_and_basic_transitions():
    obj = main()
    assert obj.state == 'K3'
    assert obj.has_max_out_edges()
    obj = main()
    result = obj.select('bend')
    assert result == 'A2'
    assert obj.state == 'K3'
    obj = main()
    result = obj.select('exit')
    assert result == 'A2'
    assert obj.state == 'K1'
    assert not obj.has_max_out_edges()
    obj = main()
    result = obj.select('amass')
    assert result == 'A2'
    assert obj.state == 'K5'


def test_k5_k0_k1_transitions():
    obj = main()
    obj.select('amass')
    result = obj.select('share')
    assert result == 'A0'
    assert obj.state == 'K0'
    obj = main()
    obj.select('amass')
    obj.select('share')
    result = obj.select('bend')
    assert result == 'A0'
    assert obj.state == 'K1'
    obj = main()
    obj.select('exit')
    result = obj.select('share')
    assert result == 'A1'
    assert obj.state == 'K3'
    obj = main()
    obj.select('exit')
    result = obj.select('amass')
    assert result == 'A0'
    assert obj.state == 'K2'


def test_k2_k4_transitions():
    obj = main()
    obj.select('exit')
    obj.select('amass')
    result = obj.select('bend')
    assert result == 'A0'
    assert obj.state == 'K4'
    obj = main()
    obj.select('exit')
    obj.select('amass')
    result = obj.select('amass')
    assert result == 'A0'
    assert obj.state == 'K2'


def test_exceptions_and_basic_paths():
    obj = main()
    result = obj.select('unknown_action')
    assert result == "MachineException: 'unknown'"
    obj = main()
    obj.select('exit')
    result = obj.select('unknown_action')
    assert result == "MachineException: 'unknown'"
    obj = main()
    obj.select('exit')
    obj.select('amass')
    obj.select('bend')
    result = obj.select('any_action')
    assert result == "MachineException: 'unknown'"
    obj = main()
    assert obj.has_path_to('K1')
    assert obj.has_path_to('K2')
    assert obj.has_path_to('K4')
    assert obj.has_path_to('K5')
    assert obj.has_path_to('K0')
    assert obj.has_path_to('K3')


def test_path_finding_edge_cases():
    obj = main()
    obj.select('exit')
    obj.select('amass')
    obj.select('bend')
    assert not obj.has_path_to('K1')
    assert not obj.has_path_to('K2')
    assert not obj.has_path_to('K3')
    assert obj.has_path_to('K4')
    obj = main()
    obj.select('exit')
    obj.select('amass')
    obj.select('bend')
    assert not obj.has_path_to('K0')
    obj = main()
    obj.select('exit')
    obj.select('amass')
    assert obj.has_path_to('K4')
    assert obj.has_path_to('K2')
    assert not obj.has_path_to('K1')
    obj = main()
    obj.select('amass')
    assert obj.has_path_to('K0')
    assert obj.has_path_to('K1')
    assert obj.has_path_to('K3')
    assert obj.has_path_to('K2')
    assert obj.has_path_to('K4')
    obj = main()
    obj.select('amass')
    obj.select('share')
    assert obj.has_path_to('K1')
    assert obj.has_path_to('K3')
    assert obj.has_path_to('K2')
    assert obj.has_path_to('K4')
    assert obj.has_path_to('K5')
    # Новый тест: Проверка повторного посещения вершины с циклом
    obj = main()
    obj.select('bend')  # K3 -> K3 (цикл)
    assert obj.has_path_to('K1')  # Проверяем путь, включая повторное посещение


def test_unsupported_actions():
    # Тест 1: Проверка 'unsupported' для K0 (share не поддерживается)
    obj = main()
    obj.select('amass')  # Переходим в K5
    obj.select('share')  # Переходим в K0
    result = obj.select('share')  # 'share' известно, но не поддерживается в K0
    assert result == "MachineException: 'unsupported'"
    assert obj.state == 'K0'  # Состояние не должно меняться
    # Тест 2: Проверка 'unsupported' для K4 (любое действие не поддерживается)
    obj = main()
    obj.select('exit')  # K3 -> K1
    obj.select('amass')  # K1 -> K2
    obj.select('bend')  # K2 -> K4
    result = obj.select('bend')  # 'bend' известно, но не поддерживается в K4
    assert result == "MachineException: 'unsupported'"
    assert obj.state == 'K4'  # Состояние не должно меняться
    # Тест 3: Проверка 'unsupported' для K1 (exit не поддерживается)
    obj = main()
    obj.select('exit')  # K3 -> K1
    result = obj.select('exit')  # 'exit' известно, но не поддерживается в K1
    assert result == "MachineException: 'unsupported'"
    assert obj.state == 'K1'  # Состояние не должно меняться


def test_has_max_out_edges_coverage():
    obj = main()
    assert obj.has_max_out_edges()
    obj.select('exit')
    assert not obj.has_max_out_edges()
    obj = main()
    obj.select('amass')
    assert not obj.has_max_out_edges()
    obj.select('share')
    assert not obj.has_max_out_edges()
    obj = main()
    obj.select('exit')
    obj.select('amass')
    assert not obj.has_max_out_edges()
    obj.select('bend')
    assert not obj.has_max_out_edges()


def test():
    test_initial_state_and_basic_transitions()
    test_k5_k0_k1_transitions()
    test_k2_k4_transitions()
    test_exceptions_and_basic_paths()
    test_path_finding_edge_cases()
    test_unsupported_actions()
    test_has_max_out_edges_coverage()


test()
