import sys
import torch
from PIL import Image
from torchvision import transforms


def load_image(image_path: str) -> torch.Tensor:
    """
    Завантажує зображення з диску, приводить його до формату,
    який очікує модель, та повертає тензор.
    """
    image = Image.open(image_path).convert("RGB")

    preprocess = transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize(
            mean=[0.485, 0.456, 0.406],
            std=[0.229, 0.224, 0.225],
        ),
    ])

    tensor = preprocess(image)
    return tensor.unsqueeze(0)  # додаємо batch-вимір


def main() -> None:
    if len(sys.argv) < 2:
        print("Використання: python inference.py <шлях_до_зображення>")
        sys.exit(1)

    image_path = sys.argv[1]

    print("Завантажую TorchScript модель...")
    model = torch.jit.load("model.pt", map_location="cpu")
    model.eval()

    print(f"Обробляю зображення: {image_path}")
    input_tensor = load_image(image_path)

    with torch.no_grad():
        outputs = model(input_tensor)
        probabilities = torch.nn.functional.softmax(outputs, dim=1)

        top_probs, top_idxs = probabilities.topk(3, dim=1)

    print("\nTop-3 передбачення:")
    for i in range(3):
        class_id = top_idxs[0, i].item()
        prob = top_probs[0, i].item()
        print(f"{i + 1}) class_id = {class_id}, probability = {prob:.4f}")


if __name__ == "__main__":
    main()
