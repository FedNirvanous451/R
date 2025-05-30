class Mealy:
    paths = {
        'K3': {
            'bend': ('K3', 'A2'),
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
        'K4': {}
    }

    def __init__(self):
        self.state = 'K3'
        self.seen = set()

    def select(self, action: str) -> str:
        if action not in self.paths[self.state]:
            if action in {act for state in self.paths.values() for act in state}:
                raise Exception('unsupported')
            else:
                raise Exception('unknown')
        new_state, output = self.paths[self.state][action]
        self.state = new_state
        return output

    def has_max_out_edges(self) -> bool:
        max_edges = max(len(actions) for actions in self.paths.values())
        return len(self.paths[self.state]) == max_edges

    def has_path_to(self, target: str) -> bool:
        visited = set()
        stack = [self.state]
        while stack:
            current = stack.pop()
            if current == target:
                return True
            if current not in visited:
                visited.add(current)
                for next_state, _ in self.paths.get(current, {}).values():
                    if next_state not in visited:
                        stack.append(next_state)
        return False


def main():
    return Mealy()


def test():
    obj = main()
    print(obj.current_dict)  # Ошибка: нет такого атрибута, нужно использовать obj.paths[obj.state]
test()