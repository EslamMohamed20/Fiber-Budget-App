
abstract class HomeStates{}
class HomeInitState extends HomeStates {}
class NavBarChangeSuccess extends HomeStates {}

class CalculateFinalResultSuccessState extends HomeStates {}
class CalculateFinalResultErrorState extends HomeStates {}

class CalculateCalcNewResultSuccessState extends HomeStates {
    final bool isDistance ;
   final bool isPower ;

  CalculateCalcNewResultSuccessState({this.isDistance, this.isPower});
}
class CalcRecommendedPowerBudgetSuccessState extends HomeStates {

  }

class PowerInputErrorState extends HomeStates {}

class CalculateBudgetResultSuccessState extends HomeStates {}
class CalculateBudgetResultErrorState extends HomeStates {}

class CalculateTotalDistanceErrorState extends HomeStates {}