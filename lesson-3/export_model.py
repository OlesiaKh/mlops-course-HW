import torch
from torchvision.models import mobilenet_v2, MobileNet_V2_Weights


def main() -> None:
    """
    Завантажуємо попередньо натреновану модель MobileNetV2 з torchvision,
    переводимо її в режим оцінки та зберігаємо у форматі TorchScript (model.pt).
    """
    # Беремо стандартні ваги для мобільної моделі
    weights = MobileNet_V2_Weights.DEFAULT
    model = mobilenet_v2(weights=weights)

    # Для інференсу нам не потрібен режим навчання
    model.eval()

    # Штучний приклад входу: одне "зображення" 3x224x224
    example_input = torch.randn(1, 3, 224, 224)

    # Створюємо TorchScript-версію моделі через trace
    traced_model = torch.jit.trace(model, example_input)

    # Зберігаємо результат у файл
    output_path = "model.pt"
    traced_model.save(output_path)
    print(f"TorchScript-модель збережено у файл: {output_path}")


if __name__ == "__main__":
    main()
