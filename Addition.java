public class Addition {
    public static void main(String[] args) {
        int num1 = 15;
        int num2 = 25;

        // Accept command line inputs if provided (e.g. java Addition 10 20)
        if (args.length >= 2) {
            try {
                num1 = Integer.parseInt(args[0]);
                num2 = Integer.parseInt(args[1]);
            } catch (NumberFormatException e) {
                System.out.println("Invalid arguments. Falling back to default values.");
            }
        }

        int sum = num1 + num2;

        System.out.println("=========================================");
        System.out.println("       JAVA ADDITION PROGRAM             ");
        System.out.println("=========================================");
        System.out.println("First Number  : " + num1);
        System.out.println("Second Number : " + num2);
        System.out.println("Result (Sum)  : " + sum);
        System.out.println("=========================================");
        System.out.println("Status: EXECUTED SUCCESSFULLY");
    }
}
